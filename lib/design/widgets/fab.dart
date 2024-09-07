import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FloatingActionButtonSpace extends StatelessWidget {
  const FloatingActionButtonSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 80);
  }
}

enum _FABType {
  regular,
  small,
  large,
  extended,
}

class AutoHideFAB extends StatefulWidget {
  final ScrollController controller;
  final Widget? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final _FABType _type;

  /// false by default.
  final bool? alwaysShow;

  const AutoHideFAB({
    super.key,
    required this.controller,
    required this.onPressed,
    this.label,
    this.child,
    this.alwaysShow,
  }) : _type = _FABType.regular;

  const AutoHideFAB.extended({
    super.key,
    required this.controller,
    required this.onPressed,
    required Widget this.label,
    required Widget? icon,
    this.alwaysShow,
  })  : _type = _FABType.extended,
        child = icon;

  @override
  State<AutoHideFAB> createState() => _AutoHideFABState();
}

class _AutoHideFABState extends State<AutoHideFAB> {
  bool showBtn = true;

  bool get alwaysShow => widget.alwaysShow ?? false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onScrollChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onScrollChanged);
    super.dispose();
  }

  void onScrollChanged() {
    final direction = widget.controller.positions.last.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      if (!showBtn) {
        setState(() {
          showBtn = true;
        });
      }
    } else if (direction == ScrollDirection.reverse) {
      if (showBtn) {
        setState(() {
          showBtn = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlideDown(
      upWhen: alwaysShow || showBtn,
      child: switch (widget._type) {
        _FABType.extended => FloatingActionButton.extended(
            icon: widget.child,
            onPressed: widget.onPressed,
            label: widget.label!,
          ),
        _FABType.regular => FloatingActionButton(
            onPressed: widget.onPressed,
            child: widget.child,
          ),
        _FABType.small => FloatingActionButton.small(
            onPressed: widget.onPressed,
            child: widget.child,
          ),
        _FABType.large => FloatingActionButton.large(
            onPressed: widget.onPressed,
            child: widget.child,
          ),
      },
    );
  }
}

// ignore: non_constant_identifier_names
Widget AnimatedSlideDown({
  required bool upWhen,
  required Widget child,
}) {
  const duration = Duration(milliseconds: 300);
  return AnimatedSlide(
    duration: duration,
    curve: Curves.fastEaseInToSlowEaseOut.flipped,
    offset: upWhen ? Offset.zero : const Offset(0, 2),
    child: child,
  );
}
