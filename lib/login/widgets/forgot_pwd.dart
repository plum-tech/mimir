import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/utils/guard_launch.dart';
import '../i18n.dart';

class ForgotPasswordButton extends StatelessWidget {
  final String url;

  const ForgotPasswordButton({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformTextButton(
      child: i18n.credentials.forgotPwd.text(
        style: const TextStyle(color: Colors.grey),
      ),
      onPressed: () {
        guardLaunchUrlString(context, url);
      },
    );
  }
}
