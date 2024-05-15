import 'package:flutter/material.dart';
import 'dart:math';

enum PopDirection {
  forwardX,
  backwardX,
}

class PartyPopper extends StatefulWidget {
  const PartyPopper({
    super.key,
    this.number = 100,
    required this.pos,
    required this.direction,
    required this.motionCurveX,
    required this.motionCurveY,
    required this.controller,
    this.segmentSize = const Size(15.0, 5.0),
  })  : assert(number > 0 && number < 500),
        assert(segmentSize > const Size(0, 0));

  //Controls the popping parameters
  final Offset pos;
  final PopDirection direction;
  final Curve motionCurveX;
  final Curve motionCurveY;
  final AnimationController controller;

  //Controls the number of pieces
  final int number;
  final Size segmentSize;

  @override
  State<PartyPopper> createState() => _PartyPopperState();
}

typedef _SegmentSpec = ({
  double horizontalStartShift,
  double verticalStartShift,
  double horizontalEndShift,
  double verticalEndShift,
  double rotateCirclesX,
  double rotateCirclesY,
  double rotateCirclesZ,
  Color color,
});

final _colors = [
  Colors.orange[800]!,
  Colors.green[800]!,
  Colors.red[800]!,
  Colors.orange[900]!,
  Colors.yellow[800]!,
  Colors.green[400]!,
  Colors.blue[800]!,
  Colors.blue[700]!,
  Colors.teal[800]!,
  Colors.purple,
  Colors.brown,
  Colors.yellow,
  Colors.red[400]!,
  Colors.pink
];

class _PartyPopperState extends State<PartyPopper> with SingleTickerProviderStateMixin {
  final rand = Random();
  final specs = <_SegmentSpec>[];

  @override
  void initState() {
    super.initState();
    generateSpecs();
  }

  void generateSpecs() {
    for (int i = 0; i < widget.number; i++) {
      specs.add((
        horizontalStartShift: (rand.nextDouble() - 0.5) * 50,
        verticalStartShift: (rand.nextDouble() - 0.5) * 150,
        horizontalEndShift: (rand.nextDouble() - 0.5) * 900,
        verticalEndShift: rand.nextDouble() * 1000,
        rotateCirclesX: rand.nextInt(7) + 1.0,
        rotateCirclesY: rand.nextInt(7) + 1.0,
        rotateCirclesZ: rand.nextInt(5) + 1.0,
        color: _colors[rand.nextInt(_colors.length)].withAlpha(rand.nextInt(55) + 200),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      return buildPoppers(box.maxWidth, box.maxHeight);
    });
  }

  Widget buildPoppers(double maxWidth, double maxHeight) {
    final segments = <Widget>[];
    for (int i = 0; i < widget.number; i++) {
      final spec = specs[i];
      segments.add(AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          final horizontalAnimation = Tween<double>(
            begin: (widget.direction == PopDirection.forwardX
                ? widget.pos.dx + spec.horizontalStartShift
                : maxWidth - widget.pos.dx - spec.horizontalStartShift),
            end: (widget.direction == PopDirection.forwardX
                ? maxWidth + spec.horizontalEndShift
                : 0.0 - spec.horizontalEndShift),
          ).animate(
            CurvedAnimation(
              parent: widget.controller,
              curve: widget.motionCurveX,
            ),
          );
          final verticalAnimation =
              Tween<double>(begin: widget.pos.dy + spec.verticalStartShift, end: maxHeight + spec.verticalEndShift)
                  .animate(
            CurvedAnimation(
              parent: widget.controller,
              curve: widget.motionCurveY,
            ),
          );
          final rotationXAnimation = Tween<double>(begin: 0, end: pi * spec.rotateCirclesX).animate(widget.controller);
          final rotationYAnimation = Tween<double>(begin: 0, end: pi * spec.rotateCirclesY).animate(widget.controller);
          final rotationZAnimation = Tween<double>(begin: 0, end: pi * spec.rotateCirclesZ).animate(widget.controller);
          return Positioned(
            width: widget.segmentSize.width,
            height: widget.segmentSize.height,
            top: verticalAnimation.value,
            left: horizontalAnimation.value,
            child: Transform(
              transform: Matrix4.rotationX(rotationXAnimation.value)
                ..rotateY(rotationYAnimation.value)
                ..rotateZ(rotationZAnimation.value),
              alignment: Alignment.center,
              child: child,
            ),
          );
        },
        child: Container(
          width: widget.segmentSize.width,
          height: widget.segmentSize.height,
          color: spec.color,
        ),
      ));
    }
    return Stack(
      children: segments,
    );
  }
}

class FunctionalCurve extends Curve {
  const FunctionalCurve(this.func);

  final double Function(double) func;

  @override
  double transform(double t) {
    return func(t);
  }
}

extension FunctionalCurveX on double Function(double) {
  Curve toCurve() => FunctionalCurve(this);
}
