import 'dart:math';

import '../entity/balance.dart';
import 'electricity.dart';

class DemoElectricityService implements ElectricityService {
  const DemoElectricityService();

  @override
  Future<ElectricityBalance> getBalance(String room) async {
    final rand = Random(room.hashCode);
    return ElectricityBalance.all(
      roomNumber: room,
      balance: rand.nextInt(10000) / 100,
    );
  }
}
