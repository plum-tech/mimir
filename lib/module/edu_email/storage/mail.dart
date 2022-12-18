import 'package:hive/hive.dart';

import '../dao/email.dart';

class MailStorage implements EmailStorageDao {
  final Box<dynamic> box;

  const MailStorage(this.box);

  @override
  String? get password => box.get('password');

  @override
  set password(String? password) => box.put('password', password);
}
