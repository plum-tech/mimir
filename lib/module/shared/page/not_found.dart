import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/route.dart';
import 'package:rettulf/rettulf.dart';

class NotFoundPage extends StatelessWidget {
  final String routeName;

  const NotFoundPage(this.routeName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: i18n.notFound404.text(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            i18n.notFound404.text(),
            Text(routeName),
            SvgPicture.asset(
              'assets/common/not-found.svg',
              width: 260,
              height: 260,
            ),
          ],
        ),
      ),
    );
  }
}
