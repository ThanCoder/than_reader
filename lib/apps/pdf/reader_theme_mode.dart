enum ReaderThemeMode {
  light,
  dark,
  // followPlatfromTheme,
  followAppTheme;

  String get label {
    if (this == light) return 'Light';
    if (this == dark) return 'Dark';
    // if (this == followPlatfromTheme) return 'Follow Platfrom Theme';
    return 'Follow App Theme';
  }

  static ReaderThemeMode fromValue(String val) {
    return values.firstWhere(
      (e) => e.name == val,
      orElse: () => followAppTheme,
    );
  }
}
