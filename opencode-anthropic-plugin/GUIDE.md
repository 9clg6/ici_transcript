# Use Anthropic Models in OpenCode with Your Claude Pro/Max Subscription

Use Claude models in [OpenCode](https://opencode.ai) using your existing Claude Pro or Max subscription — no API key needed. This works by syncing the OAuth token from Claude Code (CLI) into OpenCode.

## Prerequisites

- **macOS** (the token is stored in macOS Keychain)
- **[OpenCode](https://opencode.ai)** installed (desktop app)
- **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)** (CLI) installed and logged in
- An active **Claude Pro or Max** subscription
- **python3** available in your PATH (pre-installed on macOS)

## Setup

### 1. Make sure Claude Code is logged in

```bash
claude auth status
```

You should see something like:

```json
{
  "loggedIn": true,
  "authMethod": "claude.ai",
  "subscriptionType": "max"
}
```

If not logged in, run `claude` and follow the login flow.

### 2. Download the sync script

Save `sync-token.sh` somewhere on your machine, then make it executable:

```bash
chmod +x sync-token.sh
```

<details>
<summary>sync-token.sh</summary>

```bash
#!/bin/bash
# Sync Claude Code OAuth token to OpenCode
# Reads the token from macOS Keychain and writes it to OpenCode's auth.json

set -e

# Read Claude Code credentials from macOS Keychain
TOKEN_JSON=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null || true)
if [ -z "$TOKEN_JSON" ]; then
  echo "Error: No Claude Code credentials found in Keychain."
  echo "Make sure Claude Code is installed and you are logged in (run: claude auth status)"
  exit 1
fi

# Extract OAuth tokens
ACCESS=$(echo "$TOKEN_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['claudeAiOauth']['accessToken'])")
REFRESH=$(echo "$TOKEN_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['claudeAiOauth']['refreshToken'])")
EXPIRES=$(echo "$TOKEN_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['claudeAiOauth']['expiresAt'])")

if [ -z "$ACCESS" ] || [ -z "$REFRESH" ]; then
  echo "Error: Could not extract tokens from credentials."
  exit 1
fi

# Write to OpenCode auth.json (respects XDG_DATA_HOME)
AUTH_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/opencode"
AUTH_FILE="$AUTH_DIR/auth.json"
mkdir -p "$AUTH_DIR"

# Merge with existing auth.json to preserve other providers
if [ -f "$AUTH_FILE" ]; then
  python3 -c "
import json
try:
    with open('$AUTH_FILE') as f:
        auth = json.load(f)
except:
    auth = {}
auth['anthropic'] = {
    'type': 'oauth',
    'access': '$ACCESS',
    'refresh': '$REFRESH',
    'expires': $EXPIRES
}
with open('$AUTH_FILE', 'w') as f:
    json.dump(auth, f, indent=2)
"
else
  cat > "$AUTH_FILE" << EOF
{
  "anthropic": {
    "type": "oauth",
    "access": "$ACCESS",
    "refresh": "$REFRESH",
    "expires": $EXPIRES
  }
}
EOF
fi

echo "Done! Anthropic token synced to OpenCode."
echo "Expires: $(date -r $((EXPIRES / 1000)) 2>/dev/null || date -d @$((EXPIRES / 1000)) 2>/dev/null || echo "timestamp $EXPIRES")"
```

</details>

### 3. Run the sync script

```bash
./sync-token.sh
```

Expected output:

```
Done! Anthropic token synced to OpenCode.
Expires: Fri Mar 20 05:22:36 CET 2026
```

### 4. Verify

```bash
# Find the OpenCode CLI (adjust path if installed elsewhere)
# Desktop app:
/Applications/OpenCode.app/Contents/MacOS/opencode-cli providers list

# Or if installed via npm/homebrew:
opencode providers list
```

You should see:

```
●  Anthropic  oauth
└  1 credentials
```

### 5. Open OpenCode

Launch the OpenCode app. Anthropic models (Claude Sonnet, Opus, Haiku) should now appear in the model selector.

## Token Renewal

The OAuth token expires approximately every **6 hours**. When Anthropic models stop working in OpenCode:

1. Use Claude Code in your terminal (any command) — this automatically refreshes the token in Keychain
2. Run the sync script again:

```bash
./sync-token.sh
```

3. Restart OpenCode

### Automate with cron (optional)

To automatically sync the token every 5 hours:

```bash
crontab -e
```

Add this line (replace the path with where you saved the script):

```
0 */5 * * * /path/to/sync-token.sh
```

> **Note:** The cron job syncs the token, but Claude Code must have been used recently enough for the Keychain token to still be valid. If both tokens expire, just open Claude Code once to trigger a refresh, then run the script.

## How It Works

1. Claude Code stores its OAuth credentials in the **macOS Keychain** under `Claude Code-credentials`
2. The sync script reads this token using the `security` command
3. It writes it to `~/.local/share/opencode/auth.json` in the OAuth format that OpenCode expects:

```json
{
  "anthropic": {
    "type": "oauth",
    "access": "sk-ant-oat01-...",
    "refresh": "sk-ant-ort01-...",
    "expires": 1773980556114
  }
}
```

4. OpenCode recognizes Anthropic as an authenticated provider and exposes Claude models

## Troubleshooting

**"No Claude Code credentials found in Keychain"**
- Make sure Claude Code is installed and you've logged in at least once
- Run `claude auth status` to check

**OpenCode doesn't show Anthropic models**
- Run `opencode providers list` to verify the credential is detected
- Make sure the token hasn't expired — re-run `./sync-token.sh`
- Restart OpenCode after syncing

**Token expires too quickly**
- The token lasts ~6 hours. Use the cron automation or re-run the script manually when needed
