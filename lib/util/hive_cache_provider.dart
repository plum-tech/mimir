import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';

/// 实现Hive数据库到flutter_settings_screens库的兼容层
class HiveCacheProvider implements CacheProvider {
  final Box<dynamic> box;

  const HiveCacheProvider(this.box);

  @override
  bool containsKey(String key) {
    return box.containsKey(key);
  }

  @override
  bool? getBool(String key, {bool? defaultValue}) {
    return box.get(key, defaultValue: defaultValue);
  }

  @override
  double? getDouble(String key, {double? defaultValue}) {
    return box.get(key, defaultValue: defaultValue);
  }

  @override
  int? getInt(String key, {int? defaultValue}) {
    return box.get(key, defaultValue: defaultValue);
  }

  @override
  Set getKeys() {
    return box.keys.toSet();
  }

  @override
  String? getString(String key, {String? defaultValue}) {
    return box.get(key, defaultValue: defaultValue);
  }

  @override
  T? getValue<T>(String key, {T? defaultValue}) {
    return box.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> init() async {
    // box在外面已经初始化完毕，不需要在这里继续初始化
  }

  @override
  Future<void> remove(String key) async {
    box.delete(key);
  }

  @override
  Future<void> removeAll() async {
    box.deleteAll(box.keys);
  }

  @override
  Future<void> setBool(String key, bool? value, {bool? defaultValue = false}) async {
    box.put(key, value ?? defaultValue);
  }

  @override
  Future<void> setDouble(String key, double? value, {double? defaultValue = 0.0}) async {
    box.put(key, value ?? defaultValue);
  }

  @override
  Future<void> setInt(String key, int? value, {int? defaultValue = 0}) async {
    box.put(key, value ?? defaultValue);
  }

  @override
  Future<void> setObject<T>(String key, T? value) async {
    box.put(key, value);
  }

  @override
  Future<void> setString(String key, String? value, {String? defaultValue = ""}) async {
    box.put(key, value ?? defaultValue);
  }
}
