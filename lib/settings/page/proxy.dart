import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mimir/design/adaptive/editor.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/settings/settings.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class ProxySettingsPage extends StatefulWidget {
  const ProxySettingsPage({
    super.key,
  });

  @override
  State<ProxySettingsPage> createState() => _ProxySettingsPageState();
}

class _ProxySettingsPageState extends State<ProxySettingsPage> {
  late final StreamSubscription<BoxEvent> $address;

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
    final username = userInfoParts.elementAtOrNull(0);
    final password = userInfoParts.elementAtOrNull(1);
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
              buildProxyProtocolTile(proxyUri.scheme, (newProtocol) {
                setNewAddress(proxyUri.replace(scheme: newProtocol));
              }),
              buildProxyHostnameTile(proxyUri.host, (newHost) {
                setNewAddress(proxyUri.replace(host: newHost));
              }),
              buildProxyPortTile(proxyUri.port, (newPort) {
                setNewAddress(proxyUri.replace(port: newPort));
              }),
              buildProxyAuthTile(username != null && password != null ? (username: username, password: password) : null,
                  (newUsername) {}),
            ]),
          ),
        ],
      ),
    );
  }

  void setNewAddress(Uri uri) {
    Settings.httpProxy.address = uri.toString();
  }

  Widget buildEnableProxyToggle() {
    return Settings.httpProxy.listenHttpProxy() >>
        (ctx, _) => ListTile(
              title: i18n.proxy.enableProxyTitle.text(),
              subtitle: i18n.proxy.enableProxyDesc.text(),
              leading: const Icon(Icons.vpn_key),
              trailing: Switch.adaptive(
                value: Settings.httpProxy.enableHttpProxy,
                onChanged: validateHttpProxy(Settings.httpProxy.address)
                    ? (newV) async {
                        Settings.httpProxy.enableHttpProxy = newV;
                        await Init.init();
                      }
                    : null,
              ),
            );
  }

  Widget buildProxyProtocolTile(String protocol, ValueChanged<String> onChanged) {
    return ListTile(
      leading: const Icon(Icons.link),
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
      title: i18n.proxy.address.text(),
      subtitle: hostname.text(),
      onTap: () async {
        final newHostName = await Editor.showStringEditor(
          context,
          desc: i18n.proxy.address,
          initial: hostname,
        );
        // if (newHostName != Settings.httpProxy.address) {
        //   Settings.httpProxy.address = newHostName;
        //   await Init.init();
        // }
      },
      trailing: const Icon(Icons.edit),
    );
  }

  Widget buildProxyPortTile(int port, ValueChanged<int> onChanged) {
    return ListTile(
      leading: const Icon(Icons.settings_input_component_outlined),
      title: i18n.proxy.port.text(),
      subtitle: port.toString().text(),
      onTap: () async {
        final newPort = await Editor.showIntEditor(
          context,
          desc: i18n.proxy.port,
          initial: port,
        );
      },
      trailing: const Icon(Icons.edit),
    );
  }

  Widget buildProxyAuthTile(
    ({String username, String password})? credentials,
    ValueChanged<({String username, String password})?> onChanged,
  ) {
    final text = credentials != null ? "${credentials.username}:${credentials.password}" : null;
    return ListTile(
      leading: const Icon(Icons.person),
      title: i18n.proxy.authentication.text(),
      subtitle: text?.text(),
      onTap: () async {
        // final newPort = await Editor.showStringEditor(
        //   context,
        //   desc: i18n.proxy.username,
        //   initial: username ?? "",
        // );
      },
      trailing: const Icon(Icons.edit),
    );
  }
}

bool validateHttpProxy(String? proxy) {
  if (proxy == null) return false;
  return proxy.isNotEmpty;
}
