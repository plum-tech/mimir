import 'package:mimir/feature/feature.dart';
import 'package:statistics/statistics.dart';

extension AppFeaturesX on Iterable<AppFeature> {
  bool isFeatureEnable(AppFeature feature) {
    return contains(feature);
  }

  bool areFeaturesEnable(Iterable<AppFeature> features) {
    return containsAll(features);
  }
}
