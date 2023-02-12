import '../entity/account.dart';

abstract class ElectricityServiceDao {
  Future<Balance> getBalance(String room);
}
