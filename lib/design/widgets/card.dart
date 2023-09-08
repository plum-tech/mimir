import 'package:flutter/material.dart';

class OutlinedCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? margin;

  const OutlinedCard({
    super.key,
    this.child,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: child,
    );
  }
}

class FilledCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? margin;

  const FilledCard({
    super.key,
    this.child,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      margin: margin,
      child: child,
    );
  }
}

extension WidgetCardX on Widget {
  Widget inOutlinedCard() {
    return Builder(
      builder: (context) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: this,
      ),
    );
  }

  Widget inFilledCard() {
    return Builder(
      builder: (context) => Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: this,
      ),
    );
  }
}
