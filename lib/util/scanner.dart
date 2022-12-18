import 'package:flutter/material.dart';
import 'package:mimir/route.dart';

Future<String?> scan(BuildContext context) async {
  final result = await Navigator.of(context).pushNamed(RouteTable.scanner);
  return result as String?;
}
