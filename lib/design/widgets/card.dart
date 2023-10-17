import 'package:flutter/material.dart';

class OutlinedCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final Clip? clip;
  final Color? color;

  const OutlinedCard({
    super.key,
    this.child,
    this.margin,
    this.color,
    this.clip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      clipBehavior: clip,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color ?? Theme.of(context).colorScheme.outline,
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
  final Color? color;
  final Clip? clip;

  const FilledCard({
    super.key,
    this.child,
    this.margin,
    this.color,
    this.clip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: clip,
      color: color ?? Theme.of(context).colorScheme.surfaceVariant,
      margin: margin,
      child: child,
    );
  }
}

extension WidgetCardX on Widget {
  Widget inOutlinedCard({
    Clip? clip,
  }) {
    return Builder(
      builder: (context) => Card(
        elevation: 0,
        clipBehavior: clip,
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

  Widget inFilledCard({
    Clip? clip,
  }) {
    return Builder(
      builder: (context) => Card(
        elevation: 0,
        clipBehavior: clip,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: this,
      ),
    );
  }
}
