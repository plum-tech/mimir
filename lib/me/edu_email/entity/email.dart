import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:enough_mail_html/enough_mail_html.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/utils/date.dart';

part "email.g.dart";

@JsonSerializable()
@CopyWith(skipFields: true)
class MailEntity {
  final String subject;
  final List<MailAddress> senders;
  final List<MailAddress> recipients;
  final DateTime? date;
  final String plaintext;
  final String html;
  final String htmlDarkMode;

  const MailEntity({
    required this.subject,
    required this.senders,
    required this.recipients,
    required this.date,
    required this.plaintext,
    required this.html,
    required this.htmlDarkMode,
  });

  factory MailEntity.fromJson(Map<String, dynamic> json) => _$MailEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MailEntityToJson(this);

  String? formatDate(BuildContext context) {
    final date = this.date;
    if(date == null) return null;
    final now = DateTime.now();
    if (now.inTheSameDay(date)) {
      return context.formatHmNum(date);
    }
    return context.formatYmdNum(date);
  }

  factory MailEntity.from(MimeMessage msg) {
    final content = msg.decodeContentText();
    final soup = BeautifulSoup(content ?? "");
    var text = soup.text;
    text = text.replaceAll(_white, " ");
    return MailEntity(
      subject: msg.decodeSubject()?.trim() ?? "",
      senders: msg.decodeSender(),
      recipients: msg.recipients,
      date: msg.decodeDate(),
      plaintext: text,
      html: msg.transformToHtml(
        blockExternalImages: false,
        preferPlainText: true,
        enableDarkMode: false,
        emptyMessageText: "",
      ),
      htmlDarkMode: msg.transformToHtml(
        blockExternalImages: false,
        preferPlainText: true,
        enableDarkMode: true,
        emptyMessageText: "",
      ),
    );
  }
}

final _white = RegExp(r"\s+");

extension MailAddressEx on MailAddress {
  String get displayName {
    final personalName = this.personalName;
    return personalName != null && personalName.isNotEmpty ? personalName : email;
  }
}
