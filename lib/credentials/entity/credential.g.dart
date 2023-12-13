// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CredentialsCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Credentials(...).copyWith(id: 12, name: "My name")
  /// ````
  Credentials call({
    String? account,
    String? password,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCredentials.copyWith(...)`.
class _$CredentialsCWProxyImpl implements _$CredentialsCWProxy {
  const _$CredentialsCWProxyImpl(this._value);

  final Credentials _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Credentials(...).copyWith(id: 12, name: "My name")
  /// ````
  Credentials call({
    Object? account = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
  }) {
    return Credentials(
      account: account == const $CopyWithPlaceholder() || account == null
          ? _value.account
          // ignore: cast_nullable_to_non_nullable
          : account as String,
      password: password == const $CopyWithPlaceholder() || password == null
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
    );
  }
}

extension $CredentialsCopyWith on Credentials {
  /// Returns a callable class that can be used as follows: `instanceOfCredentials.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$CredentialsCWProxy get copyWith => _$CredentialsCWProxyImpl(this);
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CredentialsAdapter extends TypeAdapter<Credentials> {
  @override
  final int typeId = 4;

  @override
  Credentials read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Credentials(
      account: fields[0] as String,
      password: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Credentials obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.account)
      ..writeByte(1)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CredentialsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
