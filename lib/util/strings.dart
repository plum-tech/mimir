final _htmlRegex = RegExp(r"<([A-Za-z][A-Za-z0-9]*)\b[^>]*>(.*?)<\/\1>");

bool guessIsHtml(String raw) {
  return _htmlRegex.hasMatch(raw);
}

extension StringNullableExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
}

extension StringExtension on String {
  String? nullIf({required String equals}) => this == equals ? null : this;

  String notEmptyOr(String candidate) => isEmpty ? candidate : this;
}
