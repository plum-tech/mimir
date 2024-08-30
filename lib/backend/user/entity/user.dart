enum SchoolCode {
  sit("10259");

  final String code;

  const SchoolCode(this.code);

  String l10n() => name.toUpperCase();
}
