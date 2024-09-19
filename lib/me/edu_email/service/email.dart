import 'package:enough_mail/enough_mail.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/error.dart';

import '../entity/email.dart';

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
        throw CredentialException(type: CredentialErrorType.accountPassword, message: error.message);
      }
      rethrow;
    }
  }

  Future<List<MailEntity>> getInboxEmails([int count = 50]) async {
    // final mailboxes = await _client.listMailboxes();
    await _client.selectInbox();
    final result = await _client.fetchRecentMessages(messageCount: count);
    final mails = result.messages.map((msg) => MailEntity.from(msg)).toList();
    mails.sort((a, b) {
      final dateA = a.date;
      final dateB = b.date;
      if (dateA == null || dateB == null) return 0;
      return dateA.isAfter(dateB) ? -1 : 1;
    });
    return mails;
  }
}
