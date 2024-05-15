import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/party_popper.dart';

class VictoryPartyPopper extends StatefulWidget {
  final Duration duration;
  final bool pop;

  const VictoryPartyPopper({
    super.key,
    this.duration = const Duration(milliseconds: 1500),
    this.pop = false,
  });

  @override
  State<VictoryPartyPopper> createState() => _VictoryPartyPopperState();
}

class _VictoryPartyPopperState extends State<VictoryPartyPopper> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    buildController();
  }

  void buildController() {
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      }
    });
    if (widget.pop) {
      controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant VictoryPartyPopper oldWidget) {
    if (widget.duration != oldWidget.duration) {
      controller.dispose();
      buildController();
    }
    if (widget.pop != oldWidget.pop) {
      if (widget.pop) {
        controller.forward();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return [
      buildPopper(PopDirection.forwardX),
      buildPopper(PopDirection.backwardX),
    ].stack();
  }

  Widget buildPopper(PopDirection dir) {
    return PartyPopper(
      direction: dir,
      motionCurveX: (double t) {
        return -t * t / 2 + t;
      }.toCurve(),
      motionCurveY: (double t) {
        return 4 / 3 * t * t - t / 3;
      }.toCurve(),
      number: 50,
      pos: const Offset(-60.0, 30.0),
      segmentSize: const Size(15.0, 30.0),
      controller: controller,
    );
  }
}
