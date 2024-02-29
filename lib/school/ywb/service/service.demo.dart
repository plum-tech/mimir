import 'package:sit/school/ywb/entity/service.dart';

import 'service.dart';

class DemoYwbServiceService implements YwbServiceService {
  const DemoYwbServiceService();

  @override
  Future<YwbServiceDetails> getServiceDetails(String functionId) async {
    return const YwbServiceDetails(id: "0", sections: []);
  }

  @override
  Future<List<YwbService>> getServices() async {
    return [];
  }
}
