import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/design/widgets/glassmorphic.dart';
import 'package:mimir/exception/session.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/login/i18n.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../init.dart';
import '../widgets/greeting.dart';

class HomeItemGroup extends StatelessWidget {
  final List<Widget> items;

  const HomeItemGroup(this.items, {super.key});

  Widget buildGlassmorphismBg() {
    return GlassmorphismBackground(sigmaX: 5, sigmaY: 12, colors: [
      const Color(0xFFffffff).withOpacity(0.8),
      const Color(0xFF000000).withOpacity(0.8),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            buildGlassmorphismBg(),
            Column(
              children: items,
            ),
          ],
        ));
  }
}

class Homepage extends StatefulWidget {
  final Widget? leading;

  const Homepage({super.key, this.leading});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (context.auth.credential != null && await HomeInit.ssoSession.checkConnectivity()) {
        if (!mounted) return;
        context.showSnackBar(
          _i18n.campusNetworkConnected.text(),
          duration: const Duration(seconds: 3),
        );
      }
    });

    Global.eventBus.on<EventTypes>().listen((e) {
      if (e == EventTypes.onHomeItemReorder) {
        if (!mounted) return;
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    _onHomeRefresh(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  Future<void> _doLogin(BuildContext context, OaCredential oaCredential) async {
    await HomeInit.ssoSession.loginPassive(oaCredential);
  }

  void _showCheckNetwork(BuildContext context, {Widget? title}) {
    context.showSnackBar(
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Icon(Icons.dangerous),
        title ?? _i18n.campusNetworkUnconnected.text(),
        CupertinoButton(
          child: _i18n.network.openToolBtn.text(),
          onPressed: () {
            context.push("/network-tool");
          },
        )
      ]),
      duration: const Duration(seconds: 5),
    );
  }

  Future<void> _onHomeRefresh(
    BuildContext context, {
    bool loginSso = false, // 默认不登录oa，使用懒加载的方式登录
  }) async {
    final oaCredential = context.auth.credential;
    if (loginSso && oaCredential != null) {
      // 如果未登录 (老用户直接进入 Home 页不会处于登录状态, 但新用户经过 login 页时已登录)
      try {
        await _doLogin(context, oaCredential);
        if (!mounted) return;
        context.showSnackBar(_i18n.login.loggedInTip.text());
      } on Exception catch (e) {
        // 如果是认证相关问题, 弹出相应的错误信息.
        if (e is UnknownAuthException || e is CredentialsInvalidException) {
          context.showSnackBar(Text('${_i18n.login.failedWarn}: $e'));
        } else {
          // 如果是网络问题, 提示检查网络.
          _showCheckNetwork(context, title: _i18n.network.error.text());
        }
      } catch (error) {}
    }
    if (HomeInit.ssoSession.isOnline) {
      Global.eventBus.fire(EventTypes.onHomeRefresh);
    }
    _refreshController.refreshCompleted(resetFooterState: true);
  }

  Widget buildScannerButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final result = await context.push("/scanner");
        if (result is String) {
          if (Uri.tryParse(result) != null) {
            if (!mounted) return;
            await guardLaunchUrlString(context, result);
            return;
          }
        }
        if (!mounted) return;
        await context.showTip(title: "QR Code", desc: result.toString(), ok: "OK");
      },
      icon: const Icon(
        Icons.qr_code_scanner_outlined,
      ),
      iconSize: 30,
    );
  }

  Widget buildBody(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      controller: _refreshController,
      header: BezierHeader(bezierColor: Colors.white54, rectHeight: 20),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: widget.leading,
            // AppBar
            actions: [
              if (!UniversalPlatform.isDesktopOrWeb) buildScannerButton(context),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            elevation: 0,
            pinned: false,
          ),
          const GreetingWidget(),
        ],
      ),
      onRefresh: () => _onHomeRefresh(context, loginSso: true),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

const _i18n = _I18n();

class _I18n {
  const _I18n();

  static const ns = "homepage";

  final network = const NetworkI18n();
  final login = const LoginI18n();

  String get campusNetworkConnected => "$ns.campusNetworkConnected".tr();

  String get campusNetworkUnconnected => "$ns.campusNetworkUnconnected".tr();
}
