import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
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
              buildProxyAddressTile(),
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

  Widget buildProxyAddressTile() {
    return Settings.httpProxy.listenHttpProxy() >>
        (ctx, _) => ListTile(
              leading: const Icon(Icons.link),
              title: i18n.proxy.proxyAddress.text(),
              subtitle: Settings.httpProxy.address.text(),
              onTap: () async {
                final newPwd = await Editor.showStringEditor(
                  context,
                  desc: i18n.proxy.proxyAddress,
                  initial: Settings.httpProxy.address,
                );
                if (newPwd != Settings.httpProxy.address) {
                  Settings.httpProxy.address = newPwd;
                  await Init.init();
                }
              },
              trailing: const Icon(Icons.edit),
            );
  }
}

bool validateHttpProxy(String? proxy) {
  if (proxy == null) return false;
  return proxy.isNotEmpty;
}
