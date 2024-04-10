import 'package:flutter/material.dart';

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
    CardType type = CardType.plain,
  }) {
    return switch (type) {
      CardType.plain => Card(
          clipBehavior: clip,
          child: this,
        ),
      CardType.filled => Card.filled(
          clipBehavior: clip,
          child: this,
        ),
      CardType.outlined => Card.outlined(
          clipBehavior: clip,
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
