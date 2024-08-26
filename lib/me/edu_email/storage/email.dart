import 'package:hive/hive.dart';
import 'package:mimir/storage/hive/init.dart';

class EduEmailStorage {
  Box get box => HiveInit.eduEmail;

  const EduEmailStorage();
}
