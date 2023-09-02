import 'package:auto_animated/auto_animated.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/application.dart';
import '../init.dart';
import '../widgets/application.dart';
import '../using.dart';

// 本科生常用功能列表
const Set<String> _commonUsed = <String>{
  '121',
  '011',
  '047',
  '123',
  '124',
  '024',
  '125',
  '165',
  '075',
  '202',
  '023',
  '067',
  '059'
};

class ApplicationList extends StatefulWidget {
  final ValueNotifier<bool> $enableFilter;

  const ApplicationList({super.key, required this.$enableFilter});

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> with AdaptivePageProtocol {
  final service = ApplicationInit.applicationService;

  // in descending order
  List<ApplicationMeta> _allDescending = [];
  String? _lastError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _fetchMetaList().then((value) {
      if (value != null) {
        if (!mounted) return;
        value.sortBy<num>((e) => -e.count); // descending
        setState(() {
          _allDescending = value;
          _lastError = null;
        });
      }
    }).onError((error, stackTrace) {
      if (!mounted) return;
      setState(() {
        _lastError = error.toString();
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (context.isPortrait) {
      return buildPortrait(context);
    } else {
      return buildLandscape(context);
    }
  }

  Widget buildPortrait(BuildContext context) {
    final lastError = _lastError;
    if (lastError != null) {
      return lastError.text().center();
    } else if (_allDescending.isNotEmpty) {
      return buildListPortrait(_allDescending);
    } else {
      return Placeholders.loading();
    }
  }

  Widget buildBodyPortrait() {
    final lastError = _lastError;
    if (lastError != null) {
      return lastError.text().center();
    } else if (_allDescending.isNotEmpty) {
      return buildListPortrait(_allDescending);
    } else {
      return Placeholders.loading();
    }
  }

  List<Widget> buildApplications(List<ApplicationMeta> all, bool enableFilter) {
    return all
        .where((element) => !enableFilter || _commonUsed.contains(element.id))
        .mapIndexed((i, e) => ApplicationTile(meta: e, isHot: i < 3).hero(e.id))
        .toList();
  }

  Widget buildListPortrait(List<ApplicationMeta> list) {
    return widget.$enableFilter >>
        (ctx, v) {
          final items = buildApplications(list, v);
          return LiveList(
            showItemInterval: const Duration(milliseconds: 40),
            itemCount: items.length,
            itemBuilder: (ctx, index, animation) => items[index].aliveWith(animation),
          );
        };
  }

  Widget buildLandscape(BuildContext context) {
    final lastError = _lastError;
    if (lastError != null) {
      return lastError.text().center();
    } else if (_allDescending.isNotEmpty) {
      return AdaptiveNavigation(child: buildListLandscape(_allDescending));
    } else {
      return Placeholders.loading();
    }
  }

  Widget buildListLandscape(List<ApplicationMeta> list) {
    return widget.$enableFilter >>
        (ctx, v) {
          final items = buildApplications(list, v);
          return LiveGrid.options(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 500,
              mainAxisExtent: 70,
            ),
            options: commonLiveOptions,
            itemBuilder: (ctx, index, animation) => items[index].aliveWith(animation),
          );
        };
  }

  Future<List<ApplicationMeta>?> _fetchMetaList() async {
    final oaCredential = context.auth.oaCredential;
    if (oaCredential == null) return null;
    if (!ApplicationInit.session.isLogin) {
      await ApplicationInit.session.login(
        username: oaCredential.account,
        password: oaCredential.password,
      );
    }
    return await service.getApplicationMetas();
  }
}
