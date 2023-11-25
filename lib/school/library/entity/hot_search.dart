class HotSearchItem {
  String word;
  int count;

  HotSearchItem(this.word, this.count);

  @override
  String toString() {
    return 'HotSearchItem{hotSearchWord: $word, count: $count}';
  }
}
