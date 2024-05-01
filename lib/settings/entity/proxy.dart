import 'dart:typed_data';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sit/storage/hive/type_id.dart';
import 'package:sit/utils/byte_io.dart';

part "proxy.g.dart";

enum ProxyCat {
  http(
    defaultHost: "localhost",
    defaultPort: 3128,
    supportedProtocols: [
      "http",
      "https",
    ],
    defaultProtocol: "http",
  ),
  https(
    defaultHost: "localhost",
    defaultPort: 443,
    supportedProtocols: [
      "http",
      "https",
    ],
    defaultProtocol: "https",
  ),
  all(
    defaultHost: "localhost",
    defaultPort: 1080,
    supportedProtocols: [
      "socks5",
    ],
    defaultProtocol: "socks5",
  );

  final String defaultHost;
  final int defaultPort;
  final List<String> supportedProtocols;
  final String defaultProtocol;

  const ProxyCat({
    required this.defaultHost,
    required this.defaultPort,
    required this.supportedProtocols,
    required this.defaultProtocol,
  });

  Uri buildDefaultUri() => Uri(scheme: defaultProtocol, host: defaultHost, port: defaultPort);

  bool isDefaultUri(Uri uri) {
    if (uri.scheme != defaultProtocol) return false;
    if (uri.host != defaultHost) return false;
    if (uri.port != defaultPort) return false;
    if (uri.hasQuery) return false;
    if (uri.hasFragment) return false;
    if (uri.userInfo.isNotEmpty) return false;
    return true;
  }

  bool? isDefaultUriString(String? uriString) {
    if (uriString == null) return null;
    final uri = Uri.tryParse(uriString);
    if (uri == null) return null;
    return isDefaultUri(uri);
  }
}

@HiveType(typeId: CoreHiveType.proxyMode)
enum ProxyMode {
  @HiveField(0)
  global,
  @HiveField(1)
  schoolOnly;
}

@JsonSerializable()
@CopyWith(skipFields: true)
class ProxyProfile {
  static const version = 1;
  @JsonKey()
  final Uri address;
  @JsonKey()
  final bool enabled;
  @JsonKey()
  final ProxyMode mode;

  const ProxyProfile({
    required this.address,
    this.enabled = false,
    this.mode = ProxyMode.schoolOnly,
  });

  Uint8List encodeByteList() {
    final writer = ByteWriter(128);
    writer.uint8(version);
    serialize(writer);
    return writer.build();
  }

  static ProxyProfile decodeFromByteList(Uint8List bytes) {
    final reader = ByteReader(bytes);
    // ignore: unused_local_variable
    final revision = reader.uint8();
    return deserialize(reader);
  }

  void serialize(ByteWriter writer) {
    writer.strUtf8(address.toString(), ByteLength.bit16);
    writer.b(enabled);
    writer.int8(mode.index);
  }

  static ProxyProfile deserialize(ByteReader reader) {
    return ProxyProfile(
      address: Uri.parse(reader.strUtf8(ByteLength.bit16)),
      enabled: reader.b(),
      mode: ProxyMode.values[reader.int8()],
    );
  }

  factory ProxyProfile.fromJson(Map<String, dynamic> json) => _$ProxyProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProxyProfileToJson(this);

  @override
  int get hashCode => Object.hash(address, enabled, mode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProxyProfile &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          enabled == enabled &&
          mode == other.mode;
}
