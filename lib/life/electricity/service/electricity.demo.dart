import '../entity/balance.dart';
import 'electricity.dart';

class DemoElectricityService implements ElectricityService {
  const DemoElectricityService();

  @override
  Future<ElectricityBalance> getBalance(String room) async {
    return const ElectricityBalance.all(
      roomNumber: "1688",
      balance: 43.27,
    );
  }
}
