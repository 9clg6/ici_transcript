/// Extensions utilitaires sur [String].
extension StringExtensions on String {
  /// Capitalise la premiere lettre.
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Verifie si la chaine est un email valide.
  bool get isValidEmail => RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(this);

  /// Verifie si la chaine est un numero de telephone valide.
  bool get isValidPhone => RegExp(r'^[+]?[\d\s-]{10,}$').hasMatch(this);
}
