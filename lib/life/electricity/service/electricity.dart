import 'package:dio/dio.dart';
import 'package:mimir/utils/json.dart';

import '../entity/balance.dart';

const _balanceUrl = "https://xgfy.sit.edu.cn/unifri-flow/WF/Comm/ProcessRequest.do?DoType=DBAccess_RunSQLReturnTable";

class ElectricityService {
  final Dio dio;

  const ElectricityService(this.dio);

  Future<ElectricityBalance> getBalance(String room) async {
    final response = await dio.post(
      _balanceUrl,
      queryParameters: {
        "SQL": "select * from sys_room_balance where RoomName='$room';",
      },
      options: Options(
        headers: {
          "Cookie": "FK_Dept=B1101",
        },
      ),
    );
    final data = response.data as String;
    final list = data.toList(ElectricityBalance.fromJson);
    ElectricityBalance balance = list!.first;
    return balance;
  }
}
