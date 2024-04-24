import 'package:hive_flutter/hive_flutter.dart';
import 'package:sit/utils/hive.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/utils/collection.dart';

class _K {
  static const ns = '/dev';
  static const on = '$ns/on';
  static const savedOaCredentialsList = '$ns/savedOaCredentialsList';
  static const demoMode = '$ns/demoMode';
  static const expenseUserOverride = '$ns/expenseUserOverride';
}

// ignore: non_constant_identifier_names
late DevSettingsImpl Dev;

class DevSettingsImpl {
  final Box box;

  DevSettingsImpl(this.box);

  /// [false] by default.
  bool get on => box.safeGet<bool>(_K.on) ?? false;

  set on(bool newV) => box.safePut<bool>(_K.on, newV);

  late final $on = box.providerWithDefault<bool>(_K.on, () => false);

  /// [false] by default.
  bool get demoMode => box.safeGet<bool>(_K.demoMode) ?? false;

  set demoMode(bool newV) => box.safePut<bool>(_K.demoMode, newV);

  late final $demoMode = box.providerWithDefault<bool>(_K.demoMode, () => false);

  String? get expenseUserOverride => box.safeGet<String>(_K.expenseUserOverride);

  set expenseUserOverride(String? newV) => box.safePut<String>(_K.expenseUserOverride, newV);

  late final $expenseUserOverride = box.provider<String>(_K.expenseUserOverride);

  List<Credentials>? getSavedOaCredentialsList() => box.safeGet<List>(_K.savedOaCredentialsList)?.cast<Credentials>();

  Future<void> setSavedOaCredentialsList(List<Credentials>? newV) async {
    newV?.distinctBy((c) => c.account);
    await box.safePut<List>(_K.savedOaCredentialsList, newV);
  }
}
