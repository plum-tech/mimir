import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/editor.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/init.dart';
import 'package:sit/qrcode/page/view.dart';
import 'package:sit/qrcode/protocol.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class ProxySettingsPage extends StatefulWidget {
  const ProxySettingsPage({
    super.key,
  });

  @override
  State<ProxySettingsPage> createState() => _ProxySettingsPageState();
}

enum _TestConnectionState {
  notStart,
  testing,
  failed,
  success,
}

class _ProxySettingsPageState extends State<ProxySettingsPage> {
  late final StreamSubscription<BoxEvent> $address;
  var testState = _TestConnectionState.notStart;

  @override
  void initState() {
    $address = Settings.httpProxy.watchHttpProxy().listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    $address.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proxy = Settings.httpProxy.address;
    final proxyUri = Uri.tryParse(proxy) ?? Uri(scheme: "http", host: "localhost", port: 80);
    final userInfoParts = proxyUri.userInfo.split(":");
    final auth = userInfoParts.length == 2 ? (username: userInfoParts[0], password: userInfoParts[1]) : null;
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.proxy.title.text(style: context.textTheme.headlineSmall),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              buildEnableProxyToggle(),
              buildIsGlobalToggle(),
              buildProxyFullTile(proxyUri, (newProxy) {
                setNewAddress(newProxy.toString());
              }),
              const Divider(),
              buildProxyProtocolTile(proxyUri.scheme, (newProtocol) {
                setNewAddress(proxyUri.replace(scheme: newProtocol).toString());
              }),
              buildProxyHostnameTile(proxyUri.host, (newHost) {
                setNewAddress(proxyUri.replace(host: newHost).toString());
              }),
              buildProxyPortTile(proxyUri.port, (newPort) {
                setNewAddress(proxyUri.replace(port: newPort).toString());
              }),
              buildProxyAuthTile(auth, (newAuth) {
                if (newAuth == null) {
                  setNewAddress(proxyUri.replace(userInfo: "").toString());
                } else {
                  setNewAddress(
                    proxyUri
                        .replace(
                            userInfo: newAuth.password.isNotEmpty
                                ? "${newAuth.username}:${newAuth.password}"
                                : newAuth.username)
                        .toString(),
                  );
                }
              }),
              const Divider(),
              buildTestConnection(),
              buildShareQrCode(proxyUri),
            ]),
          ),
        ],
      ),
    );
  }

  Future<void> setNewAddress(String newAddress) async {
    await _setHttpProxy(newAddress);
    if (!mounted) return;
    context.showSnackBar(content: "HTTP proxy was changed".text());
  }

  Widget buildEnableProxyToggle() {
    return Settings.httpProxy.listenEnableHttpProxy() >>
        (ctx, _) => ListTile(
              title: i18n.proxy.enableProxy.text(),
              subtitle: i18n.proxy.enableProxyDesc.text(),
              leading: const Icon(Icons.vpn_key),
              trailing: Switch.adaptive(
                value: Settings.httpProxy.enableHttpProxy,
                onChanged: _validateHttpProxy(Settings.httpProxy.address)
                    ? (newV) async {
                        Settings.httpProxy.enableHttpProxy = newV;
                        await Init.initNetwork();
                      }
                    : null,
              ),
            );
  }

  Widget buildIsGlobalToggle() {
    return Settings.httpProxy.listenGlobalMode() >>
        (ctx, _) => ListTile(
              title: i18n.proxy.globalMode.text(),
              subtitle: Settings.httpProxy.globalMode
                  ? i18n.proxy.globalModeOnDesc.text()
                  : i18n.proxy.globalModeOffDesc.text(),
              leading: const Icon(Icons.public),
              trailing: Switch.adaptive(
                value: Settings.httpProxy.globalMode,
                onChanged: (newV) async {
                  Settings.httpProxy.globalMode = newV;
                  // TODO: subscribe the proxy changes instead of directly calling init.
                  if (Settings.httpProxy.enableHttpProxy) {
                    await Init.initNetwork();
                  }
                },
              ),
            );
  }

  Widget buildProxyFullTile(Uri proxyUri, ValueChanged<Uri> onChanged) {
    return ListTile(
      leading: const Icon(Icons.link),
      title: i18n.proxy.title.text(),
      subtitle: proxyUri.toString().text(),
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: proxyUri.toString()));
        if (!mounted) return;
        context.showSnackBar(content: i18n.proxy.fullCopyTip.text());
      },
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          final newFullProxy = await Editor.showStringEditor(
            context,
            desc: i18n.proxy.title,
            initial: proxyUri.toString(),
          );
          final newUri = Uri.tryParse(newFullProxy.trim());

          if (newUri != null && newUri.isAbsolute && (newUri.scheme == "http" || newUri.scheme == "https")) {
            if (newUri != proxyUri) {
              onChanged(newUri);
            }
          } else {
            // TODO: i18n
            if (!mounted) return;
            context.showTip(title: "Error", desc: "Bad proxy URI", ok: i18n.close);
            return;
          }
        },
      ),
    );
  }

  Widget buildProxyProtocolTile(String protocol, ValueChanged<String> onChanged) {
    return ListTile(
      leading: const Icon(Icons.https),
      title: i18n.proxy.protocol.text(),
      subtitle: protocol.text(),
      trailing: SegmentedButton<String>(
        selected: {protocol},
        segments: [
          ButtonSegment(value: "http", label: "HTTP".text(), icon: const Icon(Icons.http)),
          ButtonSegment(value: "https", label: "HTTPS".text(), icon: const Icon(Icons.https)),
        ],
        onSelectionChanged: (newSelection) {
          onChanged(newSelection.first);
        },
      ),
    );
  }

  Widget buildProxyHostnameTile(String hostname, ValueChanged<String> onChanged) {
    return ListTile(
      leading: const Icon(Icons.link),
      title: i18n.proxy.hostname.text(),
      subtitle: hostname.text(),
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: hostname));
        if (!mounted) return;
        context.showSnackBar(content: i18n.proxy.hostnameCopyTip.text());
      },
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          final newHostName = (await Editor.showStringEditor(
            context,
            desc: i18n.proxy.hostname,
            initial: hostname,
          ))
              .trim();
          if (newHostName != hostname) {
            onChanged(newHostName);
          }
        },
      ),
    );
  }

  Widget buildProxyPortTile(int port, ValueChanged<int> onChanged) {
    return ListTile(
      leading: const Icon(Icons.settings_input_component_outlined),
      title: i18n.proxy.port.text(),
      subtitle: port.toString().text(),
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: port.toString()));
        if (!mounted) return;
        context.showSnackBar(content: i18n.proxy.portCopyTip.text());
      },
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          final newPort = await Editor.showIntEditor(
            context,
            desc: i18n.proxy.port,
            initial: port,
          );
          if (newPort != port) {
            onChanged(newPort);
          }
        },
      ),
    );
  }

  Widget buildProxyAuthTile(
    ({String username, String password})? credentials,
    ValueChanged<({String username, String password})?> onChanged,
  ) {
    final text = credentials != null ? "${credentials.username}:${credentials.password}" : null;

    return ListTile(
      leading: const Icon(Icons.key),
      title: i18n.proxy.authentication.text(),
      subtitle: text?.text(),
      trailing: [
        if (credentials != null)
          IconButton(
            onPressed: () {
              onChanged(null);
            },
            icon: const Icon(Icons.delete),
          ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
            final newAuth = await showAdaptiveDialog<({String username, String password})>(
              context: context,
              builder: (_) => StringsEditor(
                fields: [
                  (name: "username", initial: credentials?.username ?? ""),
                  (name: "password", initial: credentials?.password ?? ""),
                ],
                title: i18n.proxy.authentication,
                ctor: (values) => (username: values[0].trim(), password: values[1].trim()),
              ),
            );
            if (newAuth != null && newAuth != credentials) {
              onChanged(newAuth);
            }
          },
        ),
      ].wrap(),
    );
  }

  Widget buildShareQrCode(Uri proxyUri) {
    return ListTile(
      leading: const Icon(Icons.qr_code),
      title: i18n.proxy.shareQrCode.text(),
      subtitle: i18n.proxy.shareQrCodeDesc.text(),
      trailing: IconButton(
        icon: const Icon(Icons.share),
        onPressed: () async {
          final qrCodeData = const HttpProxyDeepLink().encode(proxyUri);
          context.show$Sheet$(
            (context) => QrCodePage(
              title: i18n.proxy.title.text(),
              data: qrCodeData.toString(),
            ),
          );
        },
      ),
    );
  }

  Widget buildTestConnection() {
    return ListTile(
      leading: const Icon(Icons.network_check),
      title: i18n.proxy.testConnection.text(),
      subtitle: i18n.proxy.testConnectionDesc.text(),
      trailing: switch (testState) {
        _TestConnectionState.testing => const CircularProgressIndicator.adaptive(),
        _TestConnectionState.success => const Icon(Icons.check, color: Colors.green),
        _TestConnectionState.failed => Icon(Icons.public_off_rounded, color: context.$red$),
        _ => null,
      },
      onTap: () async {
        setState(() {
          testState = _TestConnectionState.testing;
        });
        final bool connected;
        try {
          connected = await Init.ssoSession.checkConnectivity();
          if (!mounted) return;
          setState(() {
            testState = connected ? _TestConnectionState.success : _TestConnectionState.failed;
          });
        } catch (error) {
          if (!mounted) return;
          setState(() {
            testState = _TestConnectionState.failed;
          });
        }
      },
    );
  }
}

bool _validateHttpProxy(String? proxy) {
  if (proxy == null) return false;
  return proxy.isNotEmpty;
}

Future<void> _setHttpProxy(String newAddress) async {
  final old = Settings.httpProxy.address;
  if (old != newAddress) {
    Settings.httpProxy.address = newAddress;
    // TODO: subscribe the proxy changes instead of directly calling init.
    // Only when proxy is enabled, it calls init.
    if (Settings.httpProxy.enableHttpProxy) {
      await Init.initNetwork();
    }
  }
}

Future<void> onHttpProxyFromQrCode({
  required BuildContext context,
  required Uri httpProxy,
}) async {
  await _setHttpProxy(httpProxy.toString());
  await HapticFeedback.mediumImpact();
  if (!context.mounted) return;
  context.showSnackBar(content: "HTTP proxy was changed from QR code".text());
  context.push("/settings/proxy");
}
