import 'package:flutter/material.dart';

enum CardVariant {
  elevated,
  filled,
  outlined;
}

extension WidgetCardX on Widget {
  Widget inOutlinedCard({
    Clip? clip,
  }) {
    return Card.outlined(
      clipBehavior: clip,
      child: this,
    );
  }

  Widget inFilledCard({
    Clip? clip,
  }) {
    return Card.filled(
      clipBehavior: clip,
      child: this,
    );
  }

  Widget inAnyCard({
    Clip? clip,
    CardVariant type = CardVariant.elevated,
  }) {
    return switch (type) {
      CardVariant.elevated => Card(
          clipBehavior: clip,
          child: this,
        ),
      CardVariant.filled => Card.filled(
          clipBehavior: clip,
          child: this,
        ),
      CardVariant.outlined => Card.outlined(
          clipBehavior: clip,
          child: this,
        ),
    };
  }
}
