import 'package:sit/utils/collection.dart';

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

String getDuplicateFileName(String origin, {List<String>? all}) {
  final (:name, :number) = _extractTrailingNumber(origin);
  if (number == null) {
    return "$origin 2";
  }
  if (all == null || all.isEmpty) {
    return "$name${number + 1}";
  }

  final nameHasLargestNumber = all
      .map((s) => _extractTrailingNumber(s))
      .map((p) {
        final number = p.number;
        return number == null ? null : (name: p.name, number: number);
      })
      .nonNulls
      .maxBy<num>((p) => p.number);

  return "$name${nameHasLargestNumber.number + 1}";
}

({String name, int? number}) _extractTrailingNumber(String s) {
  final matched = _trailingIntRe.firstMatch(s);
  if (matched == null) return (name: s, number: null);
  final prefix = matched.group(1);
  final numberRaw = matched.group(2);
  if (prefix == null || numberRaw == null) return (name: "", number: null);
  final number = int.tryParse(numberRaw, radix: 10);
  if (number == null) return (name: prefix, number: null);
  return (name: prefix, number: number);
}
