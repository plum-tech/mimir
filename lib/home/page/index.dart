import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mimir/design/utils.dart';
import 'package:mimir/events/bus.dart';
import 'package:mimir/events/events.dart';
import 'package:mimir/exception/session.dart';
import 'package:mimir/global/global.dart';
import 'package:mimir/module/login/init.dart';
import 'package:mimir/module/timetable/using.dart';
import 'package:mimir/util/scanner.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../brick_maker.dart';
import '../entity/ftype.dart';
import '../homepage_factory.dart';
import '../init.dart';
import '../widgets/drawer.dart';
import '../widgets/greeting.dart';
import 'background.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      if (Auth.hasLoggedIn && await HomeInit.ssoSession.checkConnectivity()) {
        if (!mounted) return;
        context.showSnackBar(
          i18n.homepageCampusNetworkConnected.text(),
          duration: const Duration(seconds: 3),
        );
      }
    });

    _onHomeRefresh(context);
    Global.eventBus.on<EventTypes>().listen((e) {
      if (e == EventTypes.onHomeItemReorder) {
        if (!mounted) return;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Log.info('Build Home');
    return Scaffold(
      key: _scaffoldKey,
      body: buildBody(context),
      drawer: const HomepageDrawer(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  Future<void> _doLogin(BuildContext context, OACredential oaCredential) async {
    await HomeInit.ssoSession.loginPassive(oaCredential);

    if (Kv.auth.personName == null) {
      final personName = await LoginInit.authServerService.getPersonName();
      Kv.auth.personName = personName;
    }
  }

  void _showCheckNetwork(BuildContext context, {Widget? title}) {
    context.showSnackBar(
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Icon(Icons.dangerous),
        title ?? i18n.homepageCampusNetworkDisconnected.text(),
        TextButton(
          child: i18n.openNetworkToolBtn.text(),
          onPressed: () => Navigator.of(context).pushNamed(Routes.networkTool),
        )
      ]),
      duration: const Duration(seconds: 5),
    );
  }

  Future<void> _onHomeRefresh(
    BuildContext context, {
    bool loginSso = false, // 默认不登录oa，使用懒加载的方式登录
  }) async {
    final oaCredential = Auth.oaCredential;
    if (loginSso && oaCredential != null) {
      // 如果未登录 (老用户直接进入 Home 页不会处于登录状态, 但新用户经过 login 页时已登录)
      try {
        await _doLogin(context, oaCredential);
        if (!mounted) return;
        context.showSnackBar(i18n.loginLoggedInTip.text());
      } on Exception catch (e) {
        // 如果是认证相关问题, 弹出相应的错误信息.
        if (e is UnknownAuthException || e is CredentialsInvalidException) {
          context.showSnackBar(Text('${i18n.loginFailedWarn}: $e'));
        } else {
          // 如果是网络问题, 提示检查网络.
          _showCheckNetwork(context, title: i18n.networkXcpWarn.text());
        }
      } catch (e, s) {
        Catcher.reportCheckedError(e, s);
      }
    }
    if (HomeInit.ssoSession.isOnline) {
      Global.eventBus.fire(EventTypes.onHomeRefresh);
    }
    FireOn.homepage(HomeRefreshEvent(isOnline: HomeInit.ssoSession.isOnline));
    _refreshController.refreshCompleted(resetFooterState: true);
  }

  List<Widget> buildBricksWidgets() {
    List<FType> list = Kv.home.homeItems ?? BrickMaker.makeDefaultBricks();

    // 先遍历一遍，过滤相邻重复元素
    FType lastItem = list.first;
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
      if (item == FType.separator) {
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
        final result = await scan(context);
        Log.info('扫码结果: $result');
        if (result != null) GlobalLauncher.launch(result);
      },
      icon: const Icon(
        Icons.qr_code_scanner_outlined,
      ),
      iconSize: 30,
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withAlpha(0x3F),
            Theme.of(context).isDark ? BlendMode.colorBurn : BlendMode.dst,
          ),
          child: const HomeBackground(),
        ),
        SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          header: BezierHeader(bezierColor: Colors.white54, rectHeight: 20),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                // AppBar
                actions: [
                  if (!UniversalPlatform.isDesktopOrWeb) buildScannerButton(context),
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed(Routes.settings),
                    icon: const Icon(Icons.settings),
                  ),
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Widget? buildFloatingActionButton() {
    return UniversalPlatform.isDesktopOrWeb
        ? FloatingActionButton(
            child: const Icon(Icons.refresh),
            onPressed: () async {
              // 刷新页面
              Log.info('浮动按钮被点击');
              // 触发下拉刷新
              final pos = _refreshController.position!;
              await pos.animateTo(-100,
                  duration: const Duration(milliseconds: 800), curve: Curves.fastLinearToSlowEaseIn);
            },
          )
        : null;
  }
}
