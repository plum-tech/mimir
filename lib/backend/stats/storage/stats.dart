import 'package:objectbox/objectbox.dart';
import 'package:mimir/storage/objectbox/init.dart';

import '../entity/feature.dart';
import '../entity/route.dart';

class StatsStorage {
  late final Box<StatsAppFeature> feature = ObjectBoxInit.store.box<StatsAppFeature>();
  late final Box<StatsAppRoute> route = ObjectBoxInit.store.box<StatsAppRoute>();
}
