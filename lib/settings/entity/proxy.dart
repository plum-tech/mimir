import 'package:json_annotation/json_annotation.dart';
import 'package:sit/storage/hive/type_id.dart';

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
}

@HiveType(typeId: CoreHiveType.proxyMode)
enum ProxyMode {
  @HiveField(0)
  global,
  @HiveField(1)
  schoolOnly;
}

@JsonSerializable()
class ProxyProfile {
  @JsonKey()
  final String address;
  @JsonKey()
  final bool enabled;
  @JsonKey()
  final ProxyMode mode;

  const ProxyProfile({
    required this.address,
    required this.enabled,
    required this.mode,
  });


  factory ProxyProfile.fromJson(Map<String, dynamic> json) => _$ProxyProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProxyProfileToJson(this);
}
