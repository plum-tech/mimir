import 'dart:collection';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/session/sso/session.dart';

import '../entity/local.dart';
import '../entity/remote.dart';
import 'parser.dart';

class ExpenseFetchService {
  String al2(int v) => v < 10 ? "0$v" : "$v";

  String format(DateTime d) => "${d.year}${al2(d.month)}${al2(d.day)}${al2(d.hour)}${al2(d.minute)}${al2(d.second)}";

  static const String magicNumber = "adc4ac6822fd462780f878b86cb94688";
  static const urlPath = "https://xgfy.sit.edu.cn/yktapi/services/querytransservice/querytrans";
  final SsoSession session;

  const ExpenseFetchService(this.session);

  Future<List<Transaction>> fetch({
    required String studentID,
    required DateTime from,
    required DateTime to,
  }) async {
    final curTs = format(DateTime.now());
    final fromTs = format(from);
    final toTs = format(to);
    final auth = composeAuth(studentID, fromTs, toTs, curTs);

    final res = await session.request(
      urlPath,
      ReqMethod.post,
      para: {
        'timestamp': curTs,
        'starttime': fromTs,
        'endtime': toTs,
        'sign': auth,
        'sign_method': 'HMAC',
        'stuempno': studentID,
      },
      options: SessionOptions(contentType: 'text/plain'),
    );
    final raw = parseDataPack(res.data);
    final list = raw.transactions.map(parseFull).toList();
    return list;
  }

  DataPackRaw parseDataPack(dynamic data) {
    final res = HashMap<String, dynamic>.of(data);
    final retdataRaw = res["retdata"];
    final retdata = json.decode(retdataRaw);
    res["retdata"] = retdata;
    return DataPackRaw.fromJson(res);
  }

  String composeAuth(String studentId, String from, String to, String cur) {
    final full = studentId + from + to + cur;
    final msg = utf8.encode(full);
    final key = utf8.encode(magicNumber);
    final hmac = Hmac(sha1, key);
    return hmac.convert(msg).toString();
  }
}
