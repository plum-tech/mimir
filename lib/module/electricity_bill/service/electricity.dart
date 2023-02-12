import 'package:dio/dio.dart';

import '../dao/remote.dart';
import '../entity/account.dart';
import '../using.dart';

const _balanceUrl = "https://xgfy.sit.edu.cn/unifri-flow/WF/Comm/ProcessRequest.do?DoType=DBAccess_RunSQLReturnTable";

class ElectricityService implements ElectricityServiceDao {
  final Dio dio = Dio();

  @override
  Future<Balance> getBalance(String room) async {
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
    Balance balance = data.toList(Balance.fromJson)!.first;
    return balance;
  }
}
