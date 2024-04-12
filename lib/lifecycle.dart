import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final $key = GlobalKey<NavigatorState>();
final $oaOnline = StateProvider((ref) => false);
final $schoolNetworkAvailable = StateProvider((ref) => false);
