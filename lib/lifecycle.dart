import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/r.dart';

final $key = GlobalKey<NavigatorState>();

final $oaOnline = StateProvider((ref) => false);
final $campusNetworkAvailable = StateProvider((ref) => false);
final $studentRegAvailable = StateProvider((ref) => false);

Locale get $locale => $key.currentContext?.locale ?? R.defaultLocale;
