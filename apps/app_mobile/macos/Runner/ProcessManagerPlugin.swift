import Cocoa
import FlutterMacOS

// MARK: - Server State

private enum ServerState: String {
    case stopped = "stopped"
    case starting = "starting"
    case ready = "ready"
    case error = "error"
}

// MARK: - ProcessManagerPlugin

/// Flutter plugin that manages the voxmlx-serve ML server process.
/// Launches the process, monitors stdout for a ready signal, and exposes
/// server state and log streams to Dart.
class ProcessManagerPlugin: NSObject, FlutterPlugin {

    // MARK: Channels

    private let methodChannel: FlutterMethodChannel
    private let stateEventChannel: FlutterEventChannel
    private let logsEventChannel: FlutterEventChannel

    private let stateStreamHandler = StateStreamHandler()
    private let logsStreamHandler = LogsStreamHandler()

    // MARK: Process management

    private var serverProcess: Process?
    private var stdoutPipe: Pipe?
    private var stderrPipe: Pipe?
    private var currentState: ServerState = .stopped

    private var readyPattern: String = "Uvicorn running"
    private var shutdownWorkItem: DispatchWorkItem?

    // MARK: Plugin registration

    static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "com.icitranscript/process_manager",
            binaryMessenger: registrar.messenger
        )
        let stateEventChannel = FlutterEventChannel(
            name: "com.icitranscript/server_state",
            binaryMessenger: registrar.messenger
        )
        let logsEventChannel = FlutterEventChannel(
            name: "com.icitranscript/server_logs",
            binaryMessenger: registrar.messenger
        )

        let instance = ProcessManagerPlugin(
            methodChannel: methodChannel,
            stateEventChannel: stateEventChannel,
            logsEventChannel: logsEventChannel
        )

        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        stateEventChannel.setStreamHandler(instance.stateStreamHandler)
        logsEventChannel.setStreamHandler(instance.logsStreamHandler)

        // Clean shutdown on app termination
        NotificationCenter.default.addObserver(
            instance,
            selector: #selector(applicationWillTerminate),
            name: NSApplication.willTerminateNotification,
            object: nil
        )
    }

    private init(
        methodChannel: FlutterMethodChannel,
        stateEventChannel: FlutterEventChannel,
        logsEventChannel: FlutterEventChannel
    ) {
        self.methodChannel = methodChannel
        self.stateEventChannel = stateEventChannel
        self.logsEventChannel = logsEventChannel
        super.init()
    }

    // MARK: FlutterPlugin – method call handling

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startServer":
            guard let args = call.arguments as? [String: Any],
                  let command = args["command"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing 'command' argument", details: nil))
                return
            }
            let arguments = args["args"] as? [String] ?? []
            let pattern = args["readyPattern"] as? String
            startServer(command: command, args: arguments, readyPattern: pattern, result: result)

        case "stopServer":
            stopServer(result: result)

        case "isServerRunning":
            result(serverProcess?.isRunning ?? false)

        case "getServerState":
            result(currentState.rawValue)

        case "checkCommand":
            guard let args = call.arguments as? [String: Any],
                  let command = args["command"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing 'command' argument", details: nil))
                return
            }
            checkCommand(command: command, result: result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Start Server

    private func startServer(command: String, args: [String], readyPattern: String?, result: @escaping FlutterResult) {
        guard currentState == .stopped || currentState == .error else {
            result(FlutterError(code: "ALREADY_RUNNING", message: "Server is already running or starting", details: nil))
            return
        }

        if let pattern = readyPattern {
            self.readyPattern = pattern
        }

        // Kill orphan processes first
        killOrphanProcesses(command: command)

        updateState(.starting)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: command)
        process.arguments = args

        // Inherit environment and extend PATH for common tool locations
        var env = ProcessInfo.processInfo.environment
        let home = env["HOME"] ?? NSHomeDirectory()
        let extraPaths = [
            "/usr/local/bin",
            "/opt/homebrew/bin",
            "\(home)/.local/bin",   // uv / uvx default install location
            "\(home)/.cargo/bin",   // cargo-installed tools
            "\(home)/bin",
        ]
        let currentPath = env["PATH"] ?? "/usr/bin:/bin"
        env["PATH"] = (extraPaths + [currentPath]).joined(separator: ":")
        process.environment = env

        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe

        self.stdoutPipe = stdoutPipe
        self.stderrPipe = stderrPipe

        // Read stdout
        stdoutPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard !data.isEmpty, let self = self else { return }

            if let line = String(data: data, encoding: .utf8) {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }

                self.sendLog(trimmed)

                // Check for ready signal
                if self.currentState == .starting && trimmed.contains(self.readyPattern) {
                    self.updateState(.ready)
                }
            }
        }

        // Read stderr
        stderrPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            guard !data.isEmpty, let self = self else { return }

            if let line = String(data: data, encoding: .utf8) {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }

                self.sendLog("[stderr] \(trimmed)")

                // Some servers print the ready signal to stderr
                if self.currentState == .starting && trimmed.contains(self.readyPattern) {
                    self.updateState(.ready)
                }
            }
        }

        // Handle process termination
        process.terminationHandler = { [weak self] proc in
            guard let self = self else { return }

            NSLog("[ProcessManagerPlugin] Server process terminated with status \(proc.terminationStatus)")

            self.stdoutPipe?.fileHandleForReading.readabilityHandler = nil
            self.stderrPipe?.fileHandleForReading.readabilityHandler = nil
            self.serverProcess = nil

            let finalState: ServerState = (proc.terminationStatus == 0 || self.currentState == .stopped)
                ? .stopped
                : .error

            self.updateState(finalState)
        }

        do {
            try process.run()
            self.serverProcess = process
            NSLog("[ProcessManagerPlugin] Server process started (PID: \(process.processIdentifier))")
            result(nil)
        } catch {
            updateState(.error)
            result(FlutterError(code: "LAUNCH_ERROR", message: "Failed to start server: \(error.localizedDescription)", details: nil))
        }
    }

    // MARK: - Stop Server

    private func stopServer(result: @escaping FlutterResult) {
        guard let process = serverProcess, process.isRunning else {
            updateState(.stopped)
            result(nil)
            return
        }

        NSLog("[ProcessManagerPlugin] Sending SIGTERM to server (PID: \(process.processIdentifier))")
        process.terminate() // Sends SIGTERM

        // Wait 5 seconds, then force kill
        let killWork = DispatchWorkItem { [weak self] in
            guard let self = self, let proc = self.serverProcess, proc.isRunning else { return }
            NSLog("[ProcessManagerPlugin] Server did not exit after SIGTERM, sending SIGKILL")
            kill(proc.processIdentifier, SIGKILL)
        }
        self.shutdownWorkItem = killWork
        DispatchQueue.global().asyncAfter(deadline: .now() + 5.0, execute: killWork)

        updateState(.stopped)
        result(nil)
    }

    // MARK: - Check Command Availability

    /// Resolves a command name (e.g. "uvx") to its full path by searching PATH,
    /// or returns nil if not found. This lets the Dart layer verify tool
    /// availability before attempting to start a server.
    private func checkCommand(command: String, result: @escaping FlutterResult) {
        // If it's already an absolute path, check if it exists
        if command.hasPrefix("/") {
            let exists = FileManager.default.isExecutableFile(atPath: command)
            result(exists ? command : nil)
            return
        }

        // Build the extended PATH (same as startServer)
        let env = ProcessInfo.processInfo.environment
        let home = env["HOME"] ?? NSHomeDirectory()
        let extraPaths = [
            "/usr/local/bin",
            "/opt/homebrew/bin",
            "\(home)/.local/bin",
            "\(home)/.cargo/bin",
            "\(home)/bin",
        ]
        let currentPath = env["PATH"] ?? "/usr/bin:/bin"
        let allPaths = extraPaths + currentPath.split(separator: ":").map(String.init)

        for dir in allPaths {
            let fullPath = (dir as NSString).appendingPathComponent(command)
            if FileManager.default.isExecutableFile(atPath: fullPath) {
                result(fullPath)
                return
            }
        }

        result(nil) // Not found
    }

    // MARK: - Kill Orphan Processes

    private func killOrphanProcesses(command: String) {
        // Extract the binary name from the command path
        let binaryName = (command as NSString).lastPathComponent
        guard !binaryName.isEmpty else { return }

        let pgrepProcess = Process()
        pgrepProcess.executableURL = URL(fileURLWithPath: "/usr/bin/pgrep")
        pgrepProcess.arguments = ["-f", binaryName]

        let pipe = Pipe()
        pgrepProcess.standardOutput = pipe
        pgrepProcess.standardError = FileHandle.nullDevice

        do {
            try pgrepProcess.run()
            pgrepProcess.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                let pids = output.split(separator: "\n").compactMap { Int32($0.trimmingCharacters(in: .whitespaces)) }
                let currentPid = ProcessInfo.processInfo.processIdentifier

                for pid in pids where pid != currentPid {
                    NSLog("[ProcessManagerPlugin] Killing orphan process: \(pid)")
                    kill(pid, SIGTERM)
                }
            }
        } catch {
            NSLog("[ProcessManagerPlugin] Failed to check for orphan processes: \(error)")
        }
    }

    // MARK: - State Management

    private func updateState(_ newState: ServerState) {
        currentState = newState
        NSLog("[ProcessManagerPlugin] Server state -> \(newState.rawValue)")

        DispatchQueue.main.async { [weak self] in
            self?.stateStreamHandler.send(state: newState.rawValue)
        }
    }

    // MARK: - Log Streaming

    private func sendLog(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.logsStreamHandler.send(log: message)
        }
    }

    // MARK: - App Lifecycle

    @objc private func applicationWillTerminate() {
        shutdownWorkItem?.cancel()

        if let process = serverProcess, process.isRunning {
            NSLog("[ProcessManagerPlugin] App terminating – killing server process")
            process.terminate()

            // Give a brief moment, then force kill
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                if process.isRunning {
                    kill(process.processIdentifier, SIGKILL)
                }
            }
        }
    }
}

// MARK: - StateStreamHandler

private class StateStreamHandler: NSObject, FlutterStreamHandler {

    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    func send(state: String) {
        eventSink?(state)
    }
}

// MARK: - LogsStreamHandler

private class LogsStreamHandler: NSObject, FlutterStreamHandler {

    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    func send(log: String) {
        eventSink?(log)
    }
}
