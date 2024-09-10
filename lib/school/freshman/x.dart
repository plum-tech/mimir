import 'init.dart';

class XFreshman {
  static Future<void> fetchInfo({bool preferCache = true}) async {
    if (preferCache && FreshmanInit.storage.info != null) return;
    final info = await FreshmanInit.service.fetchInfo();
    FreshmanInit.storage.info = info;
  }
}
