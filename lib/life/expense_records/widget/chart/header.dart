import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';

class ExpenseChartHeader extends StatelessWidget {
  final String upper;
  final String content;
  final String? lower;

  const ExpenseChartHeader({
    super.key,
    required this.upper,
    required this.content,
    this.lower,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.textTheme.titleMedium?.copyWith(color: context.theme.disabledColor);
    return [
      upper.text(style: labelStyle),
      content.text(style: context.textTheme.titleLarge),
      if(lower != null) lower!.text(style: labelStyle),
    ].column(caa: CrossAxisAlignment.start);
  }
}
