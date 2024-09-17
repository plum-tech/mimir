import 'package:enough_mail/enough_mail.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/error.dart';

const _server = "imap.mail.sit.edu.cn";
const _port = 993;

class MailService {
  final ImapClient _client = ImapClient(isLogEnabled: true, onBadCertificate: (_) => true);

  Future<List<Capability>> login(Credential credential) async {
    try {
      await _client.connectToServer(_server, _port, isSecure: true);
      return await _client.login(credential.account, credential.password);
    } catch (error) {
      if (error is ImapException) {
        throw CredentialsException(type: CredentialsErrorType.accountPassword, message: error.message);
      }
      rethrow;
    }
  }

  Future<FetchImapResult> getInboxMessage([int count = 30]) async {
    final mailboxes = await _client.listMailboxes();
    await _client.selectInbox();
    return await _client.fetchRecentMessages(messageCount: count);
  }
}
