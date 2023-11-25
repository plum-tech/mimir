class HotSearchItem {
  final String keyword;
  final int count;

  const HotSearchItem({
    required this.keyword,
    required this.count,
  });

  @override
  String toString() {
    return "$keyword($count)";
  }
}

class HotSearch {
  final List<HotSearchItem> recent30days;
  final List<HotSearchItem> total;

  const HotSearch({
    required this.recent30days,
    required this.total,
  });

  @override
  String toString() {
    return {
      "recent30days": recent30days,
      "total": total,
    }.toString();
  }
}
