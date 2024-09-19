import '../entity/search.dart';
import 'trends.dart';

class DemoLibraryTrendsService implements LibraryTrendsService {
  const DemoLibraryTrendsService();

  @override
  Future<LibraryTrends> getTrends() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const LibraryTrends(
      recent30days: [
        LibraryTrendsItem(keyword: '小应生活', count: 500),
        LibraryTrendsItem(keyword: 'Liplum', count: 200),
      ],
      total: [
        LibraryTrendsItem(keyword: '小应生活', count: 1000),
        LibraryTrendsItem(keyword: 'Liplum', count: 800),
      ],
    );
  }
}
