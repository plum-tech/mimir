import 'package:flutter/material.dart';

class PlainExtendedButton extends StatelessWidget {
  final Widget label;
  final Widget? icon;
  final Object? hero;
  final VoidCallback? tap;

  const PlainExtendedButton({super.key, this.hero, required this.label, this.icon, this.tap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: hero,
      icon: icon,
      backgroundColor: Colors.transparent,
      hoverColor: Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
      label: label,
      onPressed: tap,
    );
  }
}

class PlainButton extends StatelessWidget {
  final Widget? label;
  final Widget? child;
  final Object? hero;
  final VoidCallback? tap;

  const PlainButton({super.key, this.hero, this.label, this.child, this.tap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: hero,
      backgroundColor: Colors.transparent,
      hoverColor: Colors.transparent,
      elevation: 0,
      highlightElevation: 0,
      onPressed: tap,
      child: child,
    );
  }
}
