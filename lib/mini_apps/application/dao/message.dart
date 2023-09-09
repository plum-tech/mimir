import '../entity/message.dart';

abstract class ApplicationMessageDao {
  Future<ApplicationMessageCount?> getMessageCount();

  Future<ApplicationMessagePage?> getAllMessage();
}
