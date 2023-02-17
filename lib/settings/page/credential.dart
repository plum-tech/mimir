import 'package:flutter/material.dart';
import 'package:mimir/credential/i18n.dart';
import 'package:rettulf/rettulf.dart';
const _i18n = CredentialI18n();

class CredentialPage extends StatefulWidget {
  const CredentialPage({
    super.key,
  });

  @override
  State<CredentialPage> createState() => _CredentialPageState();
}

class _CredentialPageState extends State<CredentialPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: const RangeMaintainingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                title: _i18n.oaAccount.text(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

