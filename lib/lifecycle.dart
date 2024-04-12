import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final $key = GlobalKey<NavigatorState>();
final $online = StateProvider((ref) => false);
