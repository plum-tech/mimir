import 'package:flutter/widgets.dart';
import 'package:rettulf/rettulf.dart';

typedef KeyWidgetBuilder = Widget Function(BuildContext ctx, Key key);

class OmniDraggable extends StatefulWidget {
  final Offset offset;
  final Widget child;

  const OmniDraggable({super.key, required this.child, this.offset = Offset.zero});

  @override
  State<OmniDraggable> createState() => _OmniDraggableState();
}

class _OmniDraggableState extends State<OmniDraggable> with SingleTickerProviderStateMixin {
  var _x = 0.0;
  var _y = 0.0;
  final childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final ctx = childKey.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject();
        if (box is RenderBox) {
          final childSize = box.size;
          final selfSize = context.mediaQuery.size;
          setState(() {
            _x = (selfSize.width - childSize.width) / 2 + widget.offset.dx;
            _y = (selfSize.height - childSize.height) / 2 + widget.offset.dy;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return [
      Positioned(
          left: _x,
          top: _y,
          child: Listener(
            key: childKey,
            child: widget.child,
            onPointerMove: (d) {
              setState(() {
                _x += d.delta.dx;
                _y += d.delta.dy;
              });
            },
          ))
    ].stack();
  }
}
