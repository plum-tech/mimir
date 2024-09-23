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
  "221042Y213": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "2210511239": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "201032Y124": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "2210340140": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "221032Y116": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "221032Y128": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "2210450230": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "236091101": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "236091171": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "2210720129": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "221012Y108": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
  "241042Y211": (
    allow: {AppFeature.sitRobotOpenLabDoor},
    prohibit: {},
  ),
};

final Map<String, AppFeatureFilter> _schoolId2Filter = _schoolId2Features.map(
  (k, v) => MapEntry(k, AppFeatureFilter.build(allow: v.allow, prohibit: v.prohibit)),
);

AppFeatureFilter? getFeatureFilterOfSchoolId(String schoolId) {
  return _schoolId2Filter[schoolId];
}
