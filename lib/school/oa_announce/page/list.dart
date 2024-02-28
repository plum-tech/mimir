import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/design/widgets/common.dart';

import 'package:sit/school/oa_announce/widget/tile.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/utils/collection.dart';
import 'package:sit/utils/error.dart';

import '../entity/announce.dart';
import '../init.dart';
import '../i18n.dart';

class OaAnnounceListPage extends StatefulWidget {
  const OaAnnounceListPage({super.key});

  @override
  State<OaAnnounceListPage> createState() => _OaAnnounceListPageState();
}

class _OaAnnounceListPageState extends State<OaAnnounceListPage> {
  @override
  Widget build(BuildContext context) {
    final cats = OaAnnounceCat.resolve(context.auth.userType);
    return OaAnnounceListPageInternal(cats: cats);
  }
}

class OaAnnounceListPageInternal extends StatefulWidget {
  final List<OaAnnounceCat> cats;

  const OaAnnounceListPageInternal({
    super.key,
    required this.cats,
  });

  @override
  State<OaAnnounceListPageInternal> createState() => _OaAnnounceListPageInternalState();
}

class _OaAnnounceListPageInternalState extends State<OaAnnounceListPageInternal> {
  late final $loadingStates = ValueNotifier(widget.cats.map((cat) => false).toList());

  @override
  void dispose() {
    $loadingStates.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: $loadingStates >>
            (ctx, states) {
              return !states.any((state) => state == true) ? const SizedBox() : const LinearProgressIndicator();
            },
      ),
      body: DefaultTabController(
        length: widget.cats.length,
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
                    tabs: widget.cats
                        .map((cat) => Tab(
                              child: cat.l10nName().text(),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: widget.cats.mapIndexed((i, cat) {
              return OaAnnounceLoadingList(
                key: ValueKey(cat),
                cat: cat,
                onLoadingChanged: (state) {
                  final newStates = List.of($loadingStates.value);
                  newStates[i] = state;
                  $loadingStates.value = newStates;
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
  late var announcements = OaAnnounceInit.storage.getAnnouncements(widget.cat);

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
    final announcements = this.announcements;
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
          if (announcements != null)
            if (announcements.isEmpty)
              SliverFillRemaining(
                child: LeavingBlank(
                  icon: Icons.inbox_outlined,
                  desc: i18n.noOaAnnouncementsTip,
                ),
              )
            else
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
    final cat = widget.cat;
    try {
      final lastPayload = await OaAnnounceInit.service.getAnnounceList(cat, lastPage);
      final announcements = this.announcements ?? <OaAnnounceRecord>[];
      announcements.addAll(lastPayload.items);
      announcements.distinctBy((a) => a.uuid);
      announcements.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      await OaAnnounceInit.storage.setAnnouncements(cat, announcements);
      if (!mounted) return;
      setState(() {
        lastPage++;
        this.announcements = announcements;
        isFetching = false;
      });
      widget.onLoadingChanged(false);
    } catch (error, stackTrace) {
      handleRequestError(context, error, stackTrace);
      if (!mounted) return;
      setState(() {
        isFetching = false;
      });
      widget.onLoadingChanged(false);
    }
  }
}
