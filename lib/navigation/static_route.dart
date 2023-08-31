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
  Widget generateRoute(String routeName, Map<String, dynamic> args, BuildContext context) {
    if (routeName == '/' && rootRoute != null) {
      return rootRoute!(context, this, args);
    }
    final builder = table[routeName];
    if (builder != null) {
      return Builder(builder: (ctx) => builder(ctx, args));
    } else {
      return Builder(builder: (ctx) => onNotFound(context, routeName, args));
    }
  }
}
