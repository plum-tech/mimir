import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:mimir/route.dart';
import 'package:mimir/util/launcher.dart';
import 'package:mimir/util/logger.dart';
import 'package:mimir/util/rule.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalLauncher {
  static get _context => Catcher.navigatorKey!.currentContext!;
  static final _schemeLauncher = SchemeLauncher(
    schemes: [
      LaunchScheme(
        launchRule: FunctionalRule((scheme) => scheme.startsWith('http')),
        onLaunch: (scheme) async {
          if (!UniversalPlatform.isDesktopOrWeb) {
            Log.info('启动浏览器');
            Navigator.of(_context).pushNamed(
              Routes.browser,
              arguments: {'initialUrl': scheme},
            );
            return true;
          } else {
            final uri = Uri.tryParse(scheme);
            if (uri == null) return false;
            return await launchUrl(uri);
          }
        },
      ),
      LaunchScheme(
        // 其他协议，就调用launchUrl启动某个本地app
        launchRule: FunctionalRule((s) => s.contains(':')),
        onLaunch: (scheme) async {
          Log.info('尝试打开scheme: $scheme');

          final uri = Uri.tryParse(scheme);
          if (uri == null) return false;
          try {
            if (await launchUrl(uri)) {
              Log.info('成功打开scheme: $scheme');
              return true;
            } else {
              Log.info('打开失败scheme: $scheme');
              return false;
            }
          } catch (e) {
            Log.info('打开失败scheme: $scheme');
            return false;
          }
        },
      )
    ],
    onNotFound: (scheme) async {
      _context.showTip(title: '无法识别', desc: "无法识别的内容: \n$scheme", ok: '我知道了');
      return true;
    },
  );

  static Future<bool> launch(String schemeText) {
    return _schemeLauncher.launch(schemeText);
  }

  static Future<bool> launchTel(String tel) => launch('tel:$tel');

  static Future<bool> launchQqContact(String qq) =>
      launch('mqqapi://card/show_pslcard?src_type=internal&version=1&uin=$qq');
}
