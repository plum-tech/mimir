import '../entity/score.dart';

abstract class ScScoreDao {
  Future<ScScoreSummary?> getScoreSummary();

  Future<List<ScScoreItem>?> getMyScoreList();

  Future<List<ScActivityApplication>?> getMyInvolved();
}
