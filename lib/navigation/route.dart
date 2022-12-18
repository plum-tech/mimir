import 'package:flutter/widgets.dart';

typedef NamedRouteBuilder = Widget Function(
  BuildContext context,
  Map<String, dynamic> args,
);
typedef NotFoundRouteBuilder = Widget Function(
  BuildContext context,
  String routeName,
  Map<String, dynamic> args,
);

abstract class IRouteGenerator {
  // 判定该路由生成器是否能够生成指定路由名的路由
  bool accept(String routeName);

  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments);
}
