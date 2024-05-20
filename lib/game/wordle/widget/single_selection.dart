import 'package:flutter/material.dart';
import 'dart:math';
import 'group_shared.dart';

class SingleSelectionBox extends StatefulWidget {
  const SingleSelectionBox({
    super.key,
    required this.id,
    required this.unselectedChild,
    required this.selectedChild,
    //These two are displayed by animation widget so not include in the decoration parameter
    required this.selectedBackgroundColor,
    required this.unselectedBackgroundColor,
    this.shadowBlurRadius = 8,
    this.shadowSpreadRadius = 0,
    this.unselectedShadowColor = Colors.transparent,
    this.selectedShadowColor = Colors.transparent,
    this.borderRadius = 0.0,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
  });

  final int id;
  final Widget unselectedChild;
  final Widget selectedChild;
  final Color selectedBackgroundColor;
  final Color unselectedBackgroundColor;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final Color unselectedShadowColor;
  final Color selectedShadowColor;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;

  @override
  State<SingleSelectionBox> createState() => _SingleSelectionBoxState();
}

class _SingleSelectionBoxState extends State<SingleSelectionBox> with TickerProviderStateMixin {
  bool selected = false;

  //Record last pressed shift from center point
  double pressedX = 0;
  double pressedY = 0;

  //Grow animation controller
  late final AnimationController _scaleController;
  late final AnimationController _opacController;
  late final AnimationController _shrinkController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _opacController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _shrinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (context.findAncestorWidgetOfExactType<GroupSharedData>()!.selected == widget.id) {
      _scaleController.value = _scaleController.upperBound;
      selected = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var newData = context.findAncestorWidgetOfExactType<GroupSharedData>()!;
    if (newData.selected != widget.id && selected) {
      _opacController.forward();
      selected = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = GroupSharedData.of(context)!;
    //Use gesture detector to detect the position pressed for animations
    return LayoutBuilder(builder: (context, constraints) {
      var decoration = BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: data.selected == widget.id ? widget.selectedShadowColor : widget.unselectedShadowColor,
            blurRadius: widget.shadowBlurRadius,
            spreadRadius: widget.shadowSpreadRadius,
          )
        ],
        color: widget.unselectedBackgroundColor,
        border: widget.borderWidth > 0
            ? Border.all(
                color: data.selected == widget.id ? widget.selectedBackgroundColor : widget.borderColor,
                width: widget.borderWidth)
            : null,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      );
      return GestureDetector(
        //Stack best describes the relation between the animation and the container box
        onTapUp: (detail) {
          setState(() {
            selected = true;
            //Notify the group manager
            SelectNotification(selection: widget.id).dispatch(context);
            //Record the coordinate and start the animation
            pressedX = detail.localPosition.dx;
            pressedY = detail.localPosition.dy;
            _opacController.reset();
            _scaleController.reset();
            _scaleController.forward();
            _shrinkController.reverse();
          });
        },
        onTapDown: ((detail) {
          _shrinkController.value = _shrinkController.upperBound;
        }),
        onTapCancel: (() {
          _shrinkController.reverse();
        }),
        //Stack best describes the relation between the animation and the container box
        child: AnimatedBuilder(
          animation: _shrinkController,
          builder: (context, child) {
            var _shrinkAnimation = Tween<double>(begin: 1, end: 0.9).animate(CurvedAnimation(
              parent: _shrinkController,
              curve: Curves.elasticOut,
              reverseCurve: Curves.elasticIn,
            ));
            return Transform.scale(
              scale: _shrinkAnimation.value,
              alignment: Alignment.center,
              child: child,
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              //Container
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 750),
                  decoration: decoration,
                  alignment: Alignment.center,
                ),
              ),
              //Animation ( similar to ink well effect )
              Positioned.fill(
                  child: AnimatedBuilder(
                animation: _scaleController,
                child: AnimatedBuilder(
                  animation: _opacController,
                  builder: (context, child) {
                    num topLeftSquredDis = pow(pressedX, 2) + pow(pressedY, 2);
                    num topRightSquredDis = pow(constraints.maxWidth - pressedX, 2) + pow(pressedY, 2);
                    num botLeftSquredDis = pow(pressedX, 2) + pow(constraints.maxHeight - pressedY, 2);
                    num botRightSquredDis =
                        pow(constraints.maxWidth - pressedX, 2) + pow(constraints.maxHeight - pressedY, 2);
                    num radius =
                        sqrt(max(max(topLeftSquredDis, topRightSquredDis), max(botLeftSquredDis, botRightSquredDis)));
                    var _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(_opacController);
                    return OverflowBox(
                      maxHeight: radius * 2,
                      maxWidth: radius * 2,
                      child: SizedBox(
                        width: radius * 2,
                        height: radius * 2,
                        child: Opacity(
                          opacity: _opacityAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.selectedBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                builder: (context, child) {
                  var _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                    parent: _scaleController,
                    curve: Curves.easeInOutCubic,
                  ));
                  return ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Transform.translate(
                      offset: Offset(pressedX - constraints.maxWidth / 2, pressedY - constraints.maxHeight / 2),
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
              )),
              Positioned(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 750),
                  child: data.selected == widget.id ? widget.selectedChild : widget.unselectedChild,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

Widget generateSelectionBox({
  required int id,
  required double width,
  required double height,
  required Color color,
  required String primaryText,
  required double primaryTextSize,
  String? secondaryText,
  double? secondaryTextSize,
  String? decorationText,
  Alignment alignment = Alignment.center,
  EdgeInsets padding = EdgeInsets.zero,
}) {
  return Container(
    width: width,
    height: height,
    padding: const EdgeInsets.all(10.0),
    child: SingleSelectionBox(
      id: id,
      unselectedBackgroundColor: Colors.white.withOpacity(0.6),
      selectedBackgroundColor: color,
      //unselectedShadowColor: Colors.grey[400]!,
      //selectedShadowColor: color,
      borderRadius: 10.0,
      borderWidth: 0.0,
      unselectedChild: Stack(
        key: const ValueKey(0),
        children: [
          Positioned.fill(
            child: Align(
              alignment: alignment,
              child: Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        primaryText,
                        style: TextStyle(
                          color: Colors.grey[850],
                          fontWeight: FontWeight.bold,
                          fontSize: primaryTextSize,
                        ),
                      ),
                    ),
                    if (secondaryText != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          secondaryText,
                          style: TextStyle(
                            color: Colors.grey[850]!.withOpacity(0.8),
                            fontSize: secondaryTextSize,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (decorationText != null)
            Positioned.fill(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Transform.translate(
                    offset: const Offset(15, 35),
                    child: Text(
                      decorationText,
                      style: TextStyle(
                        color: color.withOpacity(0.3),
                        fontSize: 120.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ))
        ],
      ),
      selectedChild: Stack(
        key: const ValueKey(1),
        children: [
          Positioned.fill(
            child: Align(
              alignment: alignment,
              child: Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        primaryText,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: primaryTextSize,
                        ),
                      ),
                    ),
                    if (secondaryText != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          secondaryText,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: secondaryTextSize,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (decorationText != null)
            Positioned.fill(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Transform.translate(
                    offset: const Offset(15, 35),
                    child: Text(
                      decorationText,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 120.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ))
        ],
      ),
    ),
  );
}
