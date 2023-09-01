import 'package:enough_mail/enough_mail.dart';

class MailService {
  final String email;
  final String password;
  final ImapClient _client = ImapClient(isLogEnabled: true, onBadCertificate: (_) => true);

  MailService(this.email, this.password);

  Future<void> login() async {
    await _client.connectToServer('imap.mail.sit.edu.cn', 993, isSecure: true);
    await _client.login(email, password);
    await _client.listMailboxes();
  }

  Future<FetchImapResult> getInboxMessage([int count = 30]) async {
    if (!_client.isLoggedIn) {
      await login();
    }

    // final boxes = await _client.listMailboxes();
    await _client.selectInbox();
    return await _client.fetchRecentMessages(messageCount: count);
  }
}
