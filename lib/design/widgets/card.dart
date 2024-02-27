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
  final ShapeBorder? shape;

  const FilledCard({
    super.key,
    this.child,
    this.margin,
    this.color,
    this.clip,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: shape,
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

  Widget inAnyCard({
    Clip? clip,
    CardType type = CardType.plain,
  }) {
    return switch (type) {
      CardType.plain => Card(
          clipBehavior: clip,
          child: this,
        ),
      CardType.filled => FilledCard(
          clip: clip,
          child: this,
        ),
      CardType.outlined => OutlinedCard(
          clip: clip,
          child: this,
        ),
    };
  }
}

enum CardType {
  plain,
  filled,
  outlined;
}
