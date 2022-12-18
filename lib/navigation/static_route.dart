import 'package:flutter/widgets.dart';
import 'package:mimir/navigation/route.dart';

typedef RootRouteBuilder = Widget Function(
  BuildContext context,
  StaticRouteTable table,
  Map<String, dynamic> args,
);

class StaticRouteTable implements IRouteGenerator {
  final Map<String, NamedRouteBuilder> table;
  final NotFoundRouteBuilder onNotFound;
  final RootRouteBuilder? rootRoute;

  StaticRouteTable({
    required this.table,
    required this.onNotFound,
    this.rootRoute,
  });

  @override
  bool accept(String routeName) => routeName == '/' || table.containsKey(routeName);

  @override
  WidgetBuilder onGenerateRoute(String routeName, Map<String, dynamic> arguments) {
    return (context) {
      if (routeName == '/' && rootRoute != null) {
        return rootRoute!(context, this, arguments);
      }
      if (table.containsKey(routeName)) {
        return table[routeName]!(context, arguments);
      } else {
        return onNotFound(context, routeName, arguments);
      }
    };
  }
}
