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
    final proxyUri = proxy == null ? null : Uri.tryParse(proxy);
    final userInfoParts = proxyUri?.userInfo.split(":");
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
              buildProxyProtocolTile(proxyUri?.scheme ?? "http"),
              buildProxyHostnameTile(proxyUri?.host ?? ""),
              buildProxyPortTile(proxyUri?.port ?? 80),
              buildProxyUsernameTile(userInfoParts?.elementAtOrNull(0)),
              buildProxyPasswordTile(userInfoParts?.elementAtOrNull(1)),
            ]),
          ),
        ],
      ),
    );
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

  Widget buildProxyProtocolTile(String protocol) {
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

        },
      ),
    );
  }

  Widget buildProxyHostnameTile(String hostname) {
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

  Widget buildProxyPortTile(int port) {
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

  Widget buildProxyUsernameTile(String? username) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: i18n.proxy.username.text(),
      subtitle: username?.text(),
      onTap: () async {
        final newPort = await Editor.showStringEditor(
          context,
          desc: i18n.proxy.username,
          initial: username ?? "",
        );
      },
      trailing: const Icon(Icons.edit),
    );
  }

  Widget buildProxyPasswordTile(String? password) {
    return ListTile(
      leading: const Icon(Icons.password),
      title: i18n.proxy.password.text(),
      subtitle: password?.text(),
      onTap: () async {
        final newPort = await Editor.showStringEditor(
          context,
          desc: i18n.proxy.password,
          initial: password ?? "",
        );
      },
      trailing: const Icon(Icons.edit),
    );
  }
}

bool validateHttpProxy(String? proxy) {
  if (proxy == null) return false;
  return proxy.isNotEmpty;
}
