import 'package:sit/school/oa_announce/entity/announce.dart';

import 'package:sit/school/oa_announce/entity/page.dart';

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
    return const OaAnnounceListPayload(currentPage: 0, totalPage: 0, items: []);
  }
}
