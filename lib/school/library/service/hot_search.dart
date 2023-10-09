import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:sit/network/session.dart';

import '../dao/hot_search.dart';
import '../entity/hot_search.dart';
import 'constant.dart';

class HotSearchService implements HotSearchDao {
  final ISession session;

  const HotSearchService(this.session);

  HotSearchItem _parse(String rawText) {
    final texts = rawText.split('(').map((e) => e.trim()).toList();
    final title = texts.sublist(0, texts.length - 1).join('(');
    final numWithRight = texts[texts.length - 1];
    final numText = numWithRight.substring(0, numWithRight.length - 1);
    return HotSearchItem(title, int.parse(numText));
  }

  @override
  Future<HotSearch> getHotSearch() async {
    var response = await session.request(Constants.hotSearchUrl, ReqMethod.get);
    var fieldsets = BeautifulSoup(response.data).findAll('fieldset');

    List<HotSearchItem> getHotSearchItems(Bs4Element fieldset) {
      return fieldset.findAll('a').map((e) => _parse(e.text)).toList();
    }

    return HotSearch(
      recentMonth: getHotSearchItems(fieldsets[0]),
      totalTime: getHotSearchItems(fieldsets[0]),
    );
  }
}
