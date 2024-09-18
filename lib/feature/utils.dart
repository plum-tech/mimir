import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/r.dart';

///
/// Any source of AppFeature configuration can consist of two parts: allowed and prohibited.
/// As to the source, a feature can be in one of the three states: allowed, prohibited or neutral.
///
/// A feature will work only if no sources prohibit the feature.
/// Once any source prohibits the feature, it won't work.
bool can(String feature, [WidgetRef? ref]) {
  if (kDebugMode && R.debugAllFeatures) return true;
  final userType = ref == null ? CredentialsInit.storage.oa.userType : ref.watch(CredentialsInit.storage.oa.$userType);
  final campus = ref == null ? Settings.campus : ref.watch(Settings.$campus);
  final filters = [
    userType.featureFilter,
    campus.featureFilter,
  ];
  var canWork = false;
  for (final filter in filters) {
    if (filter.prohibit(feature)) {
      return false;
    }
    if (filter.allow(feature)) {
      canWork |= true;
    }
  }
  return canWork;
}
