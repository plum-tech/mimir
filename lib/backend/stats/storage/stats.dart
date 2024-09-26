import 'package:objectbox/objectbox.dart';
import 'package:mimir/storage/objectbox/init.dart';

import '../entity/feature.dart';
import '../entity/route.dart';

class StatsStorage {
  late final Box<StatsFeatureUsage> feature = ObjectBoxInit.store.box<StatsFeatureUsage>();
  late final Box<StatsRoute> route = ObjectBoxInit.store.box<StatsRoute>();
}
