String formatWithoutTrailingZeros(double amount) {
  if (amount == 0) return "0";
  final number = amount.toStringAsFixed(2);
  if (number.contains('.')) {
    int index = number.length - 1;
    while (index >= 0 && (number[index] == '0' || number[index] == '.')) {
      index--;
    }
    return number.substring(0, index + 1);
  }
  return number;
}
