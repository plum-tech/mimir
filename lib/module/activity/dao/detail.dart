import '../entity/detail.dart';

abstract class ScActivityDetailDao {
  Future<ActivityDetail?> getActivityDetail(int activityId);
}
