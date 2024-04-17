// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConnectivityStatusCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// ConnectivityStatus(...).copyWith(id: 12, name: "My name")
  /// ````
  ConnectivityStatus call({
    ConnectivityType? type,
    bool? vpnEnabled,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfConnectivityStatus.copyWith(...)`.
class _$ConnectivityStatusCWProxyImpl implements _$ConnectivityStatusCWProxy {
  const _$ConnectivityStatusCWProxyImpl(this._value);

  final ConnectivityStatus _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// ConnectivityStatus(...).copyWith(id: 12, name: "My name")
  /// ````
  ConnectivityStatus call({
    Object? type = const $CopyWithPlaceholder(),
    Object? vpnEnabled = const $CopyWithPlaceholder(),
  }) {
    return ConnectivityStatus(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as ConnectivityType?,
      vpnEnabled: vpnEnabled == const $CopyWithPlaceholder() || vpnEnabled == null
          ? _value.vpnEnabled
          // ignore: cast_nullable_to_non_nullable
          : vpnEnabled as bool,
    );
  }
}

extension $ConnectivityStatusCopyWith on ConnectivityStatus {
  /// Returns a callable class that can be used as follows: `instanceOfConnectivityStatus.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$ConnectivityStatusCWProxy get copyWith => _$ConnectivityStatusCWProxyImpl(this);
}
