// freshman.sit.edu.cn
import 'package:mimir/init.dart';
import 'package:mimir/session/freshman.dart';

import '../entity/info.dart';

class FreshmanService {
  FreshmanSession get _session => Init.freshmanSession;

  const FreshmanService();

  Future<void> fetchInfo() async {
    final res = await _session.request(
      "http://freshman.sit.edu.cn/yyyx/checkinmanageAction.do?method=personalinfoview",
    );
    final html = res.data as String;
    print(html);
  }

  FreshmanInfo _parseInfo(String html) {
    return FreshmanInfo.fromJson({});
  }
}
