import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/backend/user/card.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/me/edu_email/index.dart';
import 'package:mimir/me/widgets/greeting.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/intent/qrcode/utils.dart';
import 'package:mimir/utils/error.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import "i18n.dart";

const _qGroupNumber = "917740212";
const _joinQGroupMobileUri =
    "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=$_qGroupNumber&card_type=group&source=qrcode";
const _joinQGroupDesktopUri =
    "https://qm.qq.com/cgi-bin/qm/qr?k=9Gn1xo7NfyViy73OP-wVy-Tvzw2pW-fp&authKey=IiyjgIkoBD3I37l/ODvjonS4TwiEaceT4HSp0gxNe3kmicvPdb3opS9lQutKx1DH";
const _wechatUri = "weixin://dl/publicaccount?username=gh_61f7fd217d36";

class MePage extends ConsumerStatefulWidget {
  const MePage({super.key});

  @override
  ConsumerState<MePage> createState() => _MePageState();
}

class _MePageState extends ConsumerState<MePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleTextStyle: context.textTheme.headlineSmall,
            title: const Greeting(),
            toolbarHeight: 120,
            centerTitle: false,
            actions: [
              if (UniversalPlatform.isAndroid ||
                  UniversalPlatform.isIOS ||
                  UniversalPlatform.isMacOS ||
                  UniversalPlatform.isWeb)
                buildScannerAction(),
              PlatformIconButton(
                icon: Icon(context.icons.settings),
                onPressed: () {
                  context.push("/settings");
                },
              ),
            ],
          ),
          const UserProfileAppCard().sliver(),
          const EduEmailAppCard().sliver(),
          SliverList.list(children: [
            buildQQGroupTile(),
            buildWechatOfficialAccountTile(),
          ]),
        ],
      ),
    );
  }

  Widget buildQQGroupTile() {
    return ListTile(
      leading: const Icon(SimpleIcons.tencentqq),
      title: "QQ交流群".text(),
      subtitle: _qGroupNumber.text(),
      trailing: PlatformIconButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          try {
            if (UniversalPlatform.isIOS || UniversalPlatform.isAndroid) {
              await launchUrlString(_joinQGroupMobileUri);
            } else {
              await launchUrlString(_joinQGroupDesktopUri, mode: LaunchMode.externalNonBrowserApplication);
            }
          } catch (error, stackTrace) {
            debugPrintError(error, stackTrace);
            await Clipboard.setData(const ClipboardData(text: _qGroupNumber));
            if (!mounted) return;
            context.showSnackBar(content: i18n.copyTipOf("QQ交流群").text());
          }
        },
        icon: const Icon(Icons.group),
      ),
    );
  }

  Widget buildWechatOfficialAccountTile() {
    return ListTile(
      leading: const Icon(SimpleIcons.wechat),
      title: "微信公众号".text(),
      subtitle: "小应生活".text(),
      trailing: PlatformIconButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          try {
            await launchUrlString(_wechatUri);
          } catch (error, stackTrace) {
            debugPrintError(error, stackTrace);
          }
        },
        icon: Icon(context.icons.rightChevron),
      ),
    );
  }

  Widget buildScannerAction() {
    return PlatformIconButton(
      onPressed: () async {
        await recognizeQrCode(context);
      },
      icon: const Icon(Icons.qr_code_scanner_outlined),
    );
  }
}
