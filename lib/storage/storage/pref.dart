import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mimir/l10n/lang.dart';
import 'package:mimir/storage/storage/common.dart';

import '../dao/pref.dart';

class PrefKey {
  PrefKey._();

  static const locale = "/locale";
}

class PrefStorage extends JsonStorage implements PrefDao {
  PrefStorage(Box<dynamic> box) : super(box);

  @override
  Locale? get locale {
    return getModel<Locale>(PrefKey.locale, buildLocaleFromJson);
  }

  @override
  set locale(Locale? value) {
    setModel<Locale>(PrefKey.locale, value, (v) => v.toJson());
  }
}
