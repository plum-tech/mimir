class HotSearchItem {
  String hotSearchWord;
  int count;

  HotSearchItem(this.hotSearchWord, this.count);

  @override
  String toString() {
    return 'HotSearchItem{hotSearchWord: $hotSearchWord, count: $count}';
  }
}

class HotSearch {
  // 近30天的热搜
  List<HotSearchItem> recentMonth;

  // 总共的热搜
  List<HotSearchItem> totalTime;

  HotSearch({
    this.recentMonth = const [],
    this.totalTime = const [],
  });

  @override
  String toString() {
    return 'HotSearch{recentMonth: $recentMonth, totalTime: $totalTime}';
  }
}
