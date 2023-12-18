import '../entity/balance.dart';
import 'electricity.dart';

class DemoElectricityService implements ElectricityService {
  const DemoElectricityService();

  @override
  Future<ElectricityBalance> getBalance(String room) async {
    return const ElectricityBalance(
      roomNumber: "99999",
      balance: 99.99,
      baseBalance: 99.99,
      electricityBalance: 99.99,
    );
  }
}
