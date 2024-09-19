// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MailEntityCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// MailEntity(...).copyWith(id: 12, name: "My name")
  /// ````
  MailEntity call({
    String? subject,
    List<MailAddress>? senders,
    List<MailAddress>? recipients,
    DateTime? date,
    String? plaintext,
    String? html,
    String? htmlDarkMode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMailEntity.copyWith(...)`.
class _$MailEntityCWProxyImpl implements _$MailEntityCWProxy {
  const _$MailEntityCWProxyImpl(this._value);

  final MailEntity _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// MailEntity(...).copyWith(id: 12, name: "My name")
  /// ````
  MailEntity call({
    Object? subject = const $CopyWithPlaceholder(),
    Object? senders = const $CopyWithPlaceholder(),
    Object? recipients = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
    Object? plaintext = const $CopyWithPlaceholder(),
    Object? html = const $CopyWithPlaceholder(),
    Object? htmlDarkMode = const $CopyWithPlaceholder(),
  }) {
    return MailEntity(
      subject: subject == const $CopyWithPlaceholder() || subject == null
          ? _value.subject
          // ignore: cast_nullable_to_non_nullable
          : subject as String,
      senders: senders == const $CopyWithPlaceholder() || senders == null
          ? _value.senders
          // ignore: cast_nullable_to_non_nullable
          : senders as List<MailAddress>,
      recipients: recipients == const $CopyWithPlaceholder() || recipients == null
          ? _value.recipients
          // ignore: cast_nullable_to_non_nullable
          : recipients as List<MailAddress>,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime?,
      plaintext: plaintext == const $CopyWithPlaceholder() || plaintext == null
          ? _value.plaintext
          // ignore: cast_nullable_to_non_nullable
          : plaintext as String,
      html: html == const $CopyWithPlaceholder() || html == null
          ? _value.html
          // ignore: cast_nullable_to_non_nullable
          : html as String,
      htmlDarkMode: htmlDarkMode == const $CopyWithPlaceholder() || htmlDarkMode == null
          ? _value.htmlDarkMode
          // ignore: cast_nullable_to_non_nullable
          : htmlDarkMode as String,
    );
  }
}

extension $MailEntityCopyWith on MailEntity {
  /// Returns a callable class that can be used as follows: `instanceOfMailEntity.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$MailEntityCWProxy get copyWith => _$MailEntityCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MailEntity _$MailEntityFromJson(Map<String, dynamic> json) => MailEntity(
      subject: json['subject'] as String,
      senders: (json['senders'] as List<dynamic>).map((e) => MailAddress.fromJson(e as Map<String, dynamic>)).toList(),
      recipients:
          (json['recipients'] as List<dynamic>).map((e) => MailAddress.fromJson(e as Map<String, dynamic>)).toList(),
      date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
      plaintext: json['plaintext'] as String,
      html: json['html'] as String,
      htmlDarkMode: json['htmlDarkMode'] as String,
    );

Map<String, dynamic> _$MailEntityToJson(MailEntity instance) => <String, dynamic>{
      'subject': instance.subject,
      'senders': instance.senders,
      'recipients': instance.recipients,
      'date': instance.date?.toIso8601String(),
      'plaintext': instance.plaintext,
      'html': instance.html,
      'htmlDarkMode': instance.htmlDarkMode,
    };
