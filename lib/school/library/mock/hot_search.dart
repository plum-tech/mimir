import '../entity/hot_search.dart';

class HotSearchMock {
  Future<HotSearch> getHotSearch() async {
    // 模拟需要1s才能拿到数据的场景
    await Future.delayed(const Duration(seconds: 1));
    return HotSearch(
      recentMonth: [
        HotSearchItem('hotSearch1', 99),
        HotSearchItem('hotSearch2', 98),
        HotSearchItem('hotSearch3', 97),
        HotSearchItem('hotSearch4', 96),
      ],
      totalTime: [
        HotSearchItem('hotSearch1', 99),
        HotSearchItem('hotSearch2', 98),
        HotSearchItem('hotSearch3', 97),
        HotSearchItem('hotSearch4', 96),
      ],
    );
  }
}
