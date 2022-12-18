import 'package:hive/hive.dart';
import 'package:mimir/util/logger.dart';

import '../dao/network.dart';

class NetworkKeys {
  static const namespace = '/network';
  static const networkProxy = '$namespace/proxy';
  static const networkUseProxy = '$namespace/useProxy';
  static const networkIsGlobalProxy = '$namespace/isGlobalProxy';
}

class NetworkSettingStorage implements NetworkSettingDao {
  final Box<dynamic> box;

  NetworkSettingStorage(this.box);

  @override
  String get proxy => box.get(NetworkKeys.networkProxy, defaultValue: '');

  @override
  set proxy(String foo) => box.put(NetworkKeys.networkProxy, foo);

  @override
  bool get useProxy => box.get(NetworkKeys.networkUseProxy, defaultValue: false);

  @override
  set useProxy(bool foo) {
    Log.info('使用代理：$foo');
    box.put(NetworkKeys.networkUseProxy, foo);
  }

  @override
  bool get isGlobalProxy => box.get(NetworkKeys.networkIsGlobalProxy, defaultValue: false);

  @override
  set isGlobalProxy(bool foo) {
    box.put(NetworkKeys.networkIsGlobalProxy, foo);
  }
}
