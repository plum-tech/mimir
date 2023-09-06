import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/utils.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/design/widgets/glassmorphic.dart';
import 'package:mimir/events/bus.dart';
import 'package:mimir/events/events.dart';
import 'package:mimir/exception/session.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/login/i18n.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../brick_maker.dart';
import '../../../mini_app.dart';
import '../homepage_factory.dart';
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
    homepage.fire(HomeRefreshEvent(isOnline: HomeInit.ssoSession.isOnline));
    _refreshController.refreshCompleted(resetFooterState: true);
  }

  List<Widget> buildBricksWidgets() {
    List<MiniApp> list = BrickMaker.makeDefaultBricks(context);

    MiniApp lastItem = list.first;
    for (int i = 1; i < list.length; ++i) {
      if (lastItem == list[i]) {
        list.removeAt(i);
        i -= 1;
      } else {
        lastItem = list[i];
      }
    }

    final separator = SizedBox(height: 12.h);
    final List<Widget> result = [];
    List<Widget> currentGroup = [];

    for (final item in list) {
      if (item == MiniApp.separator) {
        result.addAll([
          HomeItemGroup([...currentGroup]),
          separator
        ]);
        currentGroup.clear();
      } else {
        final brick = HomepageFactory.buildBrickWidget(context, item);
        if (brick != null) {
          currentGroup.add(brick);
        }
      }
    }
    if (currentGroup.isNotEmpty) {
      result.add(HomeItemGroup([...currentGroup]));
      currentGroup.clear();
    }

    return [
      const GreetingWidget(),
      separator,
      ...result,
      separator,
    ];
  }

  Widget buildMainBody() {
    final items = buildBricksWidgets();
    return SliverList(
      // Functions
      delegate: SliverChildBuilderDelegate(
        (_, index) => Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: items[index],
        ),
        childCount: items.length,
      ),
    );
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
          buildMainBody(),
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
