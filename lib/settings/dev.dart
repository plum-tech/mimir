import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/utils/collection.dart';

class _K {
  static const ns = '/dev';
  static const on = '$ns/on';
  static const savedOaCredentialsList = '$ns/savedOaCredentialsList';
  static const demoMode = '$ns/demoMode';
}

// ignore: non_constant_identifier_names
late DevSettingsImpl Dev;

class DevSettingsImpl{
  final Box box;
  DevSettingsImpl(this.box);
  /// [false] by default.
  bool get on => box.get(_K.on) ?? false;

  set on(bool newV) => box.put(_K.on, newV);

  ValueListenable<Box> listenDevMode() => box.listenable(keys: [_K.on]);

  /// [false] by default.
  bool get demoMode => box.get(_K.demoMode) ?? false;

  set demoMode(bool newV) => box.put(_K.demoMode, newV);

  ValueListenable<Box> listenDemoMode() => box.listenable(keys: [_K.demoMode]);

  List<Credentials>? getSavedOaCredentialsList() =>
      (box.get(_K.savedOaCredentialsList) as List?)?.cast<Credentials>();

  Future<void> setSavedOaCredentialsList(List<Credentials>? newV) async {
    newV?.distinctBy((c) => c.account);
    await box.put(_K.savedOaCredentialsList, newV);
  }
}
