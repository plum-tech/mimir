String formatWithoutTrailingZeros(double amount) {
  if (amount == 0) return "0";
  final number = amount.toStringAsFixed(2);
  if (number.contains('.')) {
    int index = number.length - 1;
    while (index >= 0 && number[index] == '0') {
      index--;
      if (index >= 0 && number[index] == '.') {
        index--;
        break;
      }
    }
    return number.substring(0, index + 1);
  }
  return number;
}

final _trailingIntRe = RegExp(r"(.*\s+)(\d+)$");

// TODO: take other files into account
// For example:
// Files: Foo, Foo 2, Foo 3
// Duplicate "Foo 2" should result in "Foo 4"
String getDuplicateFileName(String origin) {
  final matched = _trailingIntRe.firstMatch(origin);
  if (matched == null) return "$origin 2";
  final prefix = matched.group(1);
  final number = matched.group(2);
  if (prefix == null || number == null) return "$origin 2";
  final integer = int.tryParse(number, radix: 10);
  if (integer == null) return "$origin 2";
  return "$prefix${integer + 1}";
}
