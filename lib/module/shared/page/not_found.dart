import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mimir/module/activity/using.dart';
import 'package:rettulf/rettulf.dart';

class NotFoundPage extends StatelessWidget {
  final String routeName;

  const NotFoundPage(this.routeName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "notFound404".tr().text(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            "notFound404".tr().text(),
            Text(routeName),
            SvgPicture.asset(
              'assets/common/not_found.svg',
              width: 260,
              height: 260,
            ),
          ],
        ),
      ),
    );
  }
}
