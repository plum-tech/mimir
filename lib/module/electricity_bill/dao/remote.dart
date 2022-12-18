import '../entity/account.dart';
import '../entity/statistics.dart';

abstract class ElectricityServiceDao {
  // 获取电费数据
  Future<Balance> getBalance(String room);

  // 获取排名数据
  Future<Rank> getRank(String room);

  // 获取按小时用电记录
  Future<List<HourlyBill>> getHourlyBill(String room);

  // 获取按天用电记录
  Future<List<DailyBill>> getDailyBill(String room);
}
