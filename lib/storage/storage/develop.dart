import 'package:hive/hive.dart';
import 'package:mimir/storage/dao/develop.dart';

class DevelopOptionsKeys {
  static const namespace = '/developOptions';
  static const showErrorInfoDialog = '$namespace/showErrorInfoDialog';
}

class DevelopOptionsStorage implements DevelopOptionsDao {
  final Box<dynamic> box;

  DevelopOptionsStorage(this.box);

  @override
  bool? get showErrorInfoDialog => box.get(DevelopOptionsKeys.showErrorInfoDialog);
  @override
  set showErrorInfoDialog(bool? foo) => box.put(DevelopOptionsKeys.showErrorInfoDialog, foo);
}
