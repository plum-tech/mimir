import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import "../i18n.dart";

class BalanceCard extends StatelessWidget {
  final double? elevation;
  final double balance;
  final bool removeTrailingZeros;

  const BalanceCard({
    super.key,
    required this.balance,
    this.elevation,
    this.removeTrailingZeros = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return [
      AutoSizeText(
        i18n.view.balance,
        style: textTheme.titleLarge,
        maxLines: 1,
      ),
      AutoSizeText(
        removeTrailingZeros ? _removeTrailingZeros(balance) : balance.toStringAsFixed(2),
        style: textTheme.displayLarge,
        maxLines: 1,
      ),
      AutoSizeText(
        i18n.view.rmb,
        style: textTheme.titleMedium,
        maxLines: 1,
      ),
    ]
        .column(
          mas: MainAxisSize.min,
          caa: CrossAxisAlignment.start,
        )
        .padAll(10)
        .inCard(elevation: elevation);
  }
}

String _removeTrailingZeros(double amount) {
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
