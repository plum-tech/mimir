import 'package:mimir/feature/feature.dart';
import 'package:mimir/r.dart';

final Map<String, ({Set<String> allow, Set<String> prohibit})> _schoolId2Features = {
  R.demoModeOaCredential.account: (
    allow: {},
    prohibit: {
      AppFeature.mimirUpdate,
    },
  ),
  R.demoModeOaCredentialWithoutGame.account: (
    allow: {},
    prohibit: {
      AppFeature.game$,
      AppFeature.mimirUpdate,
    },
  ),
};

final Map<String, AppFeatureFilter> _schoolId2Filter = _schoolId2Features.map(
  (k, v) => MapEntry(k, AppFeatureFilter.build(allow: v.allow, prohibit: v.prohibit)),
);

AppFeatureFilter? getFeatureFilterOfSchoolId(String schoolId) {
  return _schoolId2Filter[schoolId];
}
