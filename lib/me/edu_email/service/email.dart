import 'package:enough_mail/enough_mail.dart';
import 'package:sit/credentials/entity/email.dart';

const _server = "imap.mail.sit.edu.cn";
const _port = 993;

class MailService {
  final ImapClient _client = ImapClient(isLogEnabled: true, onBadCertificate: (_) => true);

  Future<List<Capability>> login(EmailCredentials credential) async {
    await _client.connectToServer(_server, _port, isSecure: true);
    return await _client.login(credential.address, credential.password);
  }

  Future<FetchImapResult> getInboxMessage([int count = 30]) async {
    final mailboxes = await _client.listMailboxes();
    await _client.selectInbox();
    return await _client.fetchRecentMessages(messageCount: count);
  }
}
