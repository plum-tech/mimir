import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';

class ModalImageViewer extends StatelessWidget {
  const ModalImageViewer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.black,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final UniqueKey tag = UniqueKey();
    return Hero(
      tag: tag,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return FullScreenViewer(
                  tag: tag,
                  backgroundColor: backgroundColor,
                  child: child,
                );
              },
            ),
          );
        },
        child: child,
      ),
    );
  }
}

class FullScreenViewer extends StatelessWidget {
  const FullScreenViewer({
    super.key,
    required this.child,
    required this.tag,
    this.backgroundColor = Colors.black,
  });

  final Widget child;
  final Color backgroundColor;
  final UniqueKey tag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                onDoubleTap: (){
                  Navigator.of(context).pop();
                },
                child: InteractiveViewer(
                  maxScale: 5,
                  minScale: 0.5,
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  child: child,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  PlatformIcons(context).clear,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ).padAll(16),
            ).safeArea(),
          ],
        ),
      ),
    );
  }
}
