import '../entity/holding_preview.dart';

abstract class HoldingPreviewDao {
  Future<HoldingPreviews> getHoldingPreviews(List<String> bookIdList);
}
