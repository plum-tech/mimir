import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:mimir/design/adaptive/adaptive.dart';
import 'package:mimir/design/widgets/button.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:mimir/utils/url_launcher.dart';
import 'package:rettulf/rettulf.dart';
import 'package:universal_platform/universal_platform.dart';

import '../entity/application.dart';
import '../init.dart';
import '../page/form.dart';
import '../i18n.dart';

class DetailPage extends StatefulWidget {
  final ApplicationMeta meta;

  const DetailPage({super.key, required this.meta});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  ApplicationMeta get meta => widget.meta;
  ApplicationDetail? _detail;

  @override
  void initState() {
    super.initState();
    YwbInit.applicationService.getApplicationDetail(meta.id).then((value) {
      if (!mounted) return;
      setState(() {
        _detail = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? buildPortrait(context) : buildLandscape(context);
  }

  Widget buildPortrait(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meta.name).hero(meta.id)),
      body: SafeArea(
        child: buildBody(context),
      ),
      floatingActionButton: buildOpenInAppFAB(),
    );
  }

  Widget buildOpenInAppFAB() {
    return FloatingActionButton(
      child: const Icon(Icons.east),
      onPressed: () => openInApp(context),
    );
  }

  Widget buildLandscape(BuildContext context) {
    if (context.adaptive.isSubpage) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(meta.name),
        ),
        body: SafeArea(
          child: buildBody(context),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(meta.name),
          /* actions: [
          buildOpenInApp(),
        ],*/
        ),
        body: SafeArea(
          child: buildBody(context),
        ),
      );
    }
  }

  Widget buildOpenInApp() {
    return PlainExtendedButton(
      label: i18n.open.text(),
      icon: const Icon(Icons.open_in_browser),
      tap: () => openInApp(context),
    );
  }

  Widget buildBody(
    BuildContext context,
  ) {
    final detail = _detail;
    if (detail == null) {
      return const CircularProgressIndicator();
    } else {
      final sections = detail.sections;
      sections.retainWhere((e) => e.isNotEmpty && _isValidSectionType(e));
      return ListView.separated(
        itemCount: sections.length,
        itemBuilder: (ctx, i) {
          final section = sections[i];
          return _buildSection(ctx, section);
        },
        separatorBuilder: (ctx, i) {
          return const Divider();
        },
      ).padAll(10);
    }
  }

  void openInApp(BuildContext ctx) {
    if (UniversalPlatform.isDesktopOrWeb) {
      guardLaunchUrlString(ctx, "http://ywb.sit.edu.cn/v1/#/");
    } else {
      // 跳转到申请页面
      final String applyUrl =
          'http://ywb.sit.edu.cn/v1/#/flow?src=http://ywb.sit.edu.cn/unifri-flow/WF/MyFlow.htm?FK_Flow=${meta.id}';
      ctx.navigator.push(MaterialPageRoute(builder: (_) => InAppViewPage(title: meta.name, url: applyUrl)));
    }
  }
}

bool _isValidSectionType(ApplicationDetailSection section) {
  switch (section.type) {
    case 'html':
      return true;
    case 'json':
      return true;
    default:
      return false;
  }
}

Widget _buildSection(BuildContext context, ApplicationDetailSection section) {
  final titleStyle = Theme.of(context).textTheme.headlineSmall;
  final textStyle = Theme.of(context).textTheme.bodyMedium;

  Widget buildHtmlSection(String content) {
    final html = content.replaceAll('../app/files/', 'https://xgfy.sit.edu.cn/app/files/');
    return HtmlWidget(html, textStyle: textStyle, onTapUrl: (url) {
      launchUrlInBrowser(url);
      return true;
    });
  }

  Widget buildJsonSection(String content) {
    final Map kvPairs = jsonDecode(content);
    List<Widget> items = [];
    kvPairs.forEach((key, value) => items.add(Text('$key: $value', style: textStyle)));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: items);
  }

  late Widget bodyWidget;
  switch (section.type) {
    case 'html':
      bodyWidget = buildHtmlSection(section.content);
      break;
    case 'json':
      bodyWidget = buildJsonSection(section.content);
      break;
    default:
      bodyWidget = const SizedBox();
      break;
  }

  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.section, style: titleStyle),
        bodyWidget,
      ],
    ),
  );
}
