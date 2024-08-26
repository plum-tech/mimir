import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:mimir/school/oa_announce/entity/announce.dart';

import 'package:mimir/school/oa_announce/entity/page.dart';

import 'announce.dart';

class DemoOaAnnounceService implements OaAnnounceService {
  const DemoOaAnnounceService();

  @override
  Future<OaAnnounceDetails> fetchAnnounceDetails(String catalogId, String uuid) async {
    return OaAnnounceDetails(
      title: "title",
      dateTime: DateTime.now(),
      department: "Any",
      author: "Any",
      readNumber: 100,
      content: "",
      attachments: [],
    );
  }

  @override
  Future<OaAnnounceListPayload> getAnnounceList(OaAnnounceCat cat, int pageIndex) async {
    if (pageIndex == 1) {
      final now = DateTime.now();
      final rand = Random();
      return OaAnnounceListPayload(
        currentPage: 1,
        totalPage: 1,
        items: [
          OaAnnounceRecord(
            title: '小应生活发布啦',
            uuid: "1",
            catalogId: cat.internalId,
            dateTime: DateTime.now().copyWith(day: now.day - rand.nextInt(20)),
            departments: [_departments.random(rand)],
          ),
          OaAnnounceRecord(
            title: '小应生活全新升级',
            uuid: "2",
            catalogId: cat.internalId,
            dateTime: DateTime.now().copyWith(day: now.day - rand.nextInt(20)),
            departments: [_departments.random(rand)],
          ),
          OaAnnounceRecord(
            title: '小应生活测试计划',
            uuid: "3",
            catalogId: cat.internalId,
            dateTime: DateTime.now().copyWith(day: now.day - rand.nextInt(20)),
            departments: [_departments.random(rand)],
          )
        ],
      );
    } else {
      return OaAnnounceListPayload(
        currentPage: pageIndex,
        totalPage: pageIndex,
        items: [],
      );
    }
  }
}

const _departments = [
  "开发部",
  "后勤部",
  "和平部",
  "友爱部",
  "真理部",
  "富裕部",
];
