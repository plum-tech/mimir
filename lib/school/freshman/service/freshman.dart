// freshman.sit.edu.cn
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:mimir/entity/campus.dart';
import 'package:mimir/init.dart';
import 'package:mimir/session/freshman.dart';

import '../entity/info.dart';

class FreshmanService {
  FreshmanSession get _session => Init.freshmanSession;

  const FreshmanService();

  Future<FreshmanInfo> fetchInfo() async {
    final res = await _session.request(
      "http://freshman.sit.edu.cn/yyyx/checkinmanageAction.do?method=personalinfoview",
    );
    final html = res.data as String;
    return _parseInfo(html);
  }

  static FreshmanInfo _parseInfo(String html) {
    final soup = BeautifulSoup(html);
    final title2content = <String, String>{};
    final elements = soup.findAll("td", class_: "tableHeader");
    for (final element in elements) {
      final title = element.text.trim();
      final content = element.findNextElement('td')!.text.trim();
      title2content[title] = content;
    }
    return FreshmanInfo(
      studentId: title2content["学号"]!,
      idNumber: title2content["身份证号"]!,
      name: title2content["姓名"]!,
      sex: title2content["性别"]!,
      college: title2content["录取院系"]!,
      major: title2content["录取专业"]!,
      yearClass: title2content["班级"]!,
      campus: title2content["园区"]! == "奉贤" ? Campus.fengxian : Campus.xuhui,
      buildingNumber: title2content["楼宇"]!,
      roomNumber: title2content["房间"]!,
      bedNumber: title2content["床位"]!,
      counselorName: title2content["辅导员姓名"]!,
      counselorContact: title2content["辅导员联系方式"]!,
      counselorNote: title2content["辅导员补充说明"]!,
    );
  }
}
