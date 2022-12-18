part of 'adaptive.dart';

class AdaptiveUI extends InheritedWidget {
  final bool isSubpage;

  const AdaptiveUI({super.key, required this.isSubpage, required super.child});

  @override
  bool updateShouldNotify(covariant AdaptiveUI oldWidget) {
    return isSubpage != oldWidget.isSubpage;
  }

  static AdaptiveUI of(BuildContext ctx) {
    final result = ctx.dependOnInheritedWidgetOfExactType<AdaptiveUI>();
    assert(result != null, 'No RouteType found in context');
    return result!;
  }

  Route<T> makeRoute<T>(
    WidgetBuilder builder, {
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    if (isSubpage) {
      return SubpageRoute<T>(
          builder: builder, settings: settings, maintainState: maintainState, fullscreenDialog: fullscreenDialog);
    } else {
      return MaterialPageRoute<T>(
          builder: builder, settings: settings, maintainState: maintainState, fullscreenDialog: fullscreenDialog);
    }
  }
}

extension AdapativeEx on BuildContext {
  AdaptiveUI get adaptive => AdaptiveUI.of(this);
}

mixin AdaptivePageProtocol<T extends StatefulWidget> on State<T> {
  var navigatorKey = GlobalKey();

  NavigatorState? get navigator => navigatorKey.currentState as NavigatorState?;

  // ignore: non_constant_identifier_names
  Widget AdaptiveNavigation({required Widget child}) {
    return Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) {
          return context.adaptive.makeRoute((ctx) {
            return child;
          });
        });
  }
}

class SubpageRoute<T> extends MaterialPageRoute<T> {
  SubpageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(builder: builder, maintainState: maintainState, settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
