import 'package:mimir/school/ywb/entity/service.dart';

import 'service.dart';

class DemoYwbServiceService implements YwbServiceService {
  const DemoYwbServiceService();

  @override
  Future<YwbServiceDetails> getServiceDetails(String functionId) async {
    await Future.delayed(const Duration(milliseconds: 1300));
    return const YwbServiceDetails(id: "0", sections: []);
  }

  @override
  Future<List<YwbService>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 1180));
    return [
      const YwbService(
        id: "1",
        name: "小应生活账号 申请",
        summary: "申请一个新的小应生活账号",
        status: 1,
        count: 1875,
        iconName: "icon-add-account",
      ),
      const YwbService(
        id: "2",
        name: "小应生活账号注销",
        summary: "注销你的小应生活张海",
        status: 1,
        count: 24,
        iconName: "icon-yingjian",
      ),
      const YwbService(
        id: "3",
        name: "小应生活线下身份验证",
        summary: "线下验证小应生活账号的学生身份",
        status: 1,
        count: 5,
        iconName: "",
      ),
    ];
  }
}
