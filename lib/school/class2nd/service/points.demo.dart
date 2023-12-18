import '../entity/attended.dart';
import 'points.dart';

class DemoClass2ndPointsService implements Class2ndPointsService {
  const DemoClass2ndPointsService();

  @override
  Future<Class2ndPointsSummary> fetchScoreSummary() async {
    return const Class2ndPointsSummary(
      thematicReport: 1.5,
      practice: 2.0,
      creation: 1.5,
      schoolSafetyCivilization: 1.0,
      voluntary: 1.0,
      schoolCulture: 1.0,
      honestyPoints: 10.0,
      totalPoints: 8.0,
    );
  }

  @override
  Future<List<Class2ndPointItem>> fetchScoreItemList() async {
    // TODO: mock this
    return [];
  }

  @override
  Future<List<Class2ndActivityApplication>> fetchActivityApplicationList() async {
    // TODO: mock this
    return [];
  }
}
