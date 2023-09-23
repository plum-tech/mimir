import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/common.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/application.dart';
import '../init.dart';
import '../widgets/mail.dart';
import '../i18n.dart';

class YwbMailboxPage extends StatefulWidget {
  const YwbMailboxPage({super.key});

  @override
  State<YwbMailboxPage> createState() => _YwbMailboxPageState();
}

class _YwbMailboxPageState extends State<YwbMailboxPage> {
  MyYwbApplications? applications;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      final myApplication = await YwbInit.applicationService.getMyApplications();
      if (!mounted) return;
      setState(() {
        applications = myApplication;
        isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final applications = this.applications;
    return Scaffold(
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: isLoading ? const LinearProgressIndicator() : const SizedBox(),
      ),
      body: DefaultTabController(
        length: YwbApplicationType.values.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  title: i18n.title.text(),
                  actions: [],
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: YwbApplicationType.values
                        .mapIndexed(
                          (i, e) => Tab(
                            child: e.l10nName().text(),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: YwbApplicationType.values.map((type) {
              if (applications == null) return const SizedBox();
              return YwbMailList(applications.resolve(type));
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class YwbMailList extends StatelessWidget {
  final List<YwbApplication> applications;

  const YwbMailList(
    this.applications, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          // This is the flip side of the SliverOverlapAbsorber above.
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        if (applications.isEmpty)
          SliverFillRemaining(
            child: LeavingBlank(
              icon: Icons.inbox_outlined,
              desc: i18n.mailbox.noMailsTip,
            ),
          )
        else
          SliverList.builder(
            itemCount: applications.length,
            itemBuilder: (ctx, i) => YwbApplicationTile(applications[i]),
          )
      ],
    );
  }
}
