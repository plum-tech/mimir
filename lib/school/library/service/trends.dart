import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/session/library.dart';

import '../api.dart';
import '../entity/search.dart';

class LibraryTrendsService {
  LibrarySession get _session => Init.librarySession;

  const LibraryTrendsService();

  LibraryTrendsItem _parse(String rawText) {
    final texts = rawText.split('(').map((e) => e.trim()).toList();
    final title = texts.sublist(0, texts.length - 1).join('(');
    final numWithRight = texts[texts.length - 1];
    final numText = numWithRight.substring(0, numWithRight.length - 1);
    return LibraryTrendsItem(
      keyword: title,
      count: int.parse(numText),
    );
  }

  Future<LibraryTrends> getTrends() async {
    final response = await _session.request(
      LibraryApi.hotSearchUrl,
      options: Options(
        method: "GET",
      ),
    );
    final soup = BeautifulSoup(response.data);
    final fieldsets = soup.findAll('fieldset');

    List<LibraryTrendsItem> getHotSearchItems(Bs4Element fieldset) {
      return fieldset.findAll('a').map((e) => _parse(e.text)).toList();
    }

    return LibraryTrends(
      recent30days: getHotSearchItems(fieldsets[0]),
      total: getHotSearchItems(fieldsets[1]),
    );
  }
}
