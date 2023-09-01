import '../entity/message.dart';

abstract class ApplicationMessageDao {
  Future<ApplicationMsgCount?> getMessageCount();

  Future<ApplicationMsgPage?> getAllMessage();
}
