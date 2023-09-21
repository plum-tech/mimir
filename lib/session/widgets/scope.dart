import 'package:flutter/widgets.dart';

class OaOnlineManager extends StatefulWidget {
  final Widget child;

  const OaOnlineManager({
    super.key,
    required this.child,
  });

  @override
  State<OaOnlineManager> createState() => OaOnlineManagerState();
}

class OaOnlineManagerState extends State<OaOnlineManager> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    return OaOnlineScope(
      isOnline: _isOnline,
      child: widget.child,
    );
  }

  static OaOnlineManagerState of(BuildContext context) {
    final OaOnlineManagerState? result = context.findAncestorStateOfType<OaOnlineManagerState>();
    assert(result != null, 'No OaOnlineScope found in context');
    return result!;
  }

  bool get isOnline => _isOnline;

  set isOnline(bool newV) {
    if (_isOnline != newV) {
      setState(() {
        _isOnline = newV;
      });
    }
  }
}

class OaOnlineScope extends InheritedWidget {
  final bool isOnline;

  const OaOnlineScope({
    super.key,
    required this.isOnline,
    required Widget child,
  }) : super(child: child);

  static OaOnlineScope of(BuildContext context) {
    final OaOnlineScope? result = context.dependOnInheritedWidgetOfExactType<OaOnlineScope>();
    assert(result != null, 'No OaOnlineScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(OaOnlineScope oldWidget) {
    return isOnline != oldWidget.isOnline;
  }
}
