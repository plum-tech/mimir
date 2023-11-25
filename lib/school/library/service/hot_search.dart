import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/library.dart';

import '../entity/hot_search.dart';
import '../constant.dart';

class HotSearchService {
  LibrarySession get session => Init.librarySession;

  const HotSearchService();

  HotSearchItem _parse(String rawText) {
    final texts = rawText.split('(').map((e) => e.trim()).toList();
    final title = texts.sublist(0, texts.length - 1).join('(');
    final numWithRight = texts[texts.length - 1];
    final numText = numWithRight.substring(0, numWithRight.length - 1);
    return HotSearchItem(title, int.parse(numText));
  }

  Future<List<HotSearchItem>> getHotSearch() async {
    final response = await session.request(LibraryConst.hotSearchUrl, ReqMethod.get);
    final soup = BeautifulSoup(response.data);
    final fieldsets = soup.findAll('fieldset');

    List<HotSearchItem> getHotSearchItems(Bs4Element fieldset) {
      return fieldset.findAll('a').map((e) => _parse(e.text)).toList();
    }

    return getHotSearchItems(fieldsets[0]);
  }
}
