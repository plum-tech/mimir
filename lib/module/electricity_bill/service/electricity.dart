import '../dao/remote.dart';
import '../entity/account.dart';
import '../entity/statistics.dart';
import '../using.dart';

class ElectricityService implements ElectricityServiceDao {
  static const String _baseUrl = '/electricity/room';

  final ISession session;

  const ElectricityService(this.session);

  @override
  Future<Balance> getBalance(String room) async {
    final response = await session.request('$_baseUrl/$room', ReqMethod.get);

    Balance balance = Balance.fromJson(response.data);

    return balance;
  }

  @override
  Future<List<DailyBill>> getDailyBill(String room) async {
    final response = await session.request('$_baseUrl/$room/bill/days', ReqMethod.get);
    List<dynamic> list = response.data;
    return list.map((e) => DailyBill.fromJson(e)).toList();
  }

  @override
  Future<List<HourlyBill>> getHourlyBill(String room) async {
    final response = await session.request('$_baseUrl/$room/bill/hours', ReqMethod.get);
    List<dynamic> list = response.data;
    return list.map((e) => HourlyBill.fromJson(e)).toList();
  }

  @override
  Future<Rank> getRank(String room) async {
    final response = await session.request('$_baseUrl/$room/rank', ReqMethod.get);
    final rank = Rank.fromJson(response.data);

    return rank;
  }
}
