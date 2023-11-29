import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/widgets/card.dart';

import 'package:sit/school/oa_announce/widget/tile.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/utils/collection.dart';

import '../entity/announce.dart';
import '../init.dart';
import '../i18n.dart';

const _commonOaAnnounceCats = [
  OaAnnounceCat.learning,
  OaAnnounceCat.studentAffairs,
  OaAnnounceCat.announcement,
  OaAnnounceCat.culture,
  OaAnnounceCat.download,
  OaAnnounceCat.collegeNotification,
  OaAnnounceCat.life,
];

class OaAnnounceListPage extends StatefulWidget {
  const OaAnnounceListPage({super.key});

  @override
  State<OaAnnounceListPage> createState() => _OaAnnounceListPageState();
}

class _OaAnnounceListPageState extends State<OaAnnounceListPage> {
  final loadingStates = ValueNotifier(_commonOaAnnounceCats.map((cat) => false).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: loadingStates >>
            (ctx, states) {
              return !states.any((state) => state == true) ? const SizedBox() : const LinearProgressIndicator();
            },
      ),
      body: DefaultTabController(
        length: _commonOaAnnounceCats.length,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  floating: true,
                  title: i18n.title.text(),
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: _commonOaAnnounceCats
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
            children: _commonOaAnnounceCats.mapIndexed((i, cat) {
              return OaAnnounceLoadingList(
                cat: cat,
                onLoadingChanged: (state) {
                  final newStates = List.of(loadingStates.value);
                  newStates[i] = state;
                  loadingStates.value = newStates;
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class OaAnnounceLoadingList extends StatefulWidget {
  final OaAnnounceCat cat;
  final ValueChanged<bool> onLoadingChanged;

  const OaAnnounceLoadingList({
    super.key,
    required this.cat,
    required this.onLoadingChanged,
  });

  @override
  State<OaAnnounceLoadingList> createState() => _OaAnnounceLoadingListState();
}

class _OaAnnounceLoadingListState extends State<OaAnnounceLoadingList> with AutomaticKeepAliveClientMixin {
  int lastPage = 1;
  bool isFetching = false;
  late List<OaAnnounceRecord> announcements =
      OaAnnounceInit.storage.getAnnouncements(widget.cat) ?? <OaAnnounceRecord>[];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      await loadMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (event) {
        if (event.metrics.pixels >= event.metrics.maxScrollExtent) {
          loadMore();
        }
        return true;
      },
      child: CustomScrollView(
        // CAN'T USE ScrollController, and I don't know why
        // controller: scrollController,
        slivers: <Widget>[
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverList.builder(
            itemCount: announcements.length,
            itemBuilder: (ctx, index) {
              return FilledCard(
                clip: Clip.hardEdge,
                child: OaAnnounceTile(announcements[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> loadMore() async {
    if (isFetching) return;
    if (!mounted) return;
    setState(() {
      isFetching = true;
    });
    widget.onLoadingChanged(true);
    try {
      final lastPayload = await OaAnnounceInit.service.getAnnounceList(widget.cat, lastPage);
      announcements.addAll(lastPayload.items);
      announcements.distinctBy((a) => a.uuid);
      announcements.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      await OaAnnounceInit.storage.setAnnouncements(widget.cat, announcements);
      if (!mounted) return;
      setState(() {
        lastPage++;
        isFetching = false;
      });
      widget.onLoadingChanged(false);
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
      widget.onLoadingChanged(false);
    }
  }
}
