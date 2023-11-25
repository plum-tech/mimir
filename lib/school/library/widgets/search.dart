import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/search.dart';

const _searchMethods = [
  SearchMethod.any,
  SearchMethod.title,
  SearchMethod.author,
  SearchMethod.isbn,
  SearchMethod.publisher,
];

class SearchMethodSwitcher extends StatelessWidget {
  final List<SearchMethod> all;
  final SearchMethod selected;
  final ValueChanged<SearchMethod>? onSelect;

  const SearchMethodSwitcher({
    super.key,
    this.all = _searchMethods,
    required this.selected,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: all.length,
      itemBuilder: (ctx, i) {
        final method = all[i];
        return ChoiceChip(
          label: method.l10nName().text(),
          selected: selected == method,
          onSelected: (value) {
            if (value) {
              onSelect?.call(method);
            }
          },
        ).padH(4);
      },
    );
  }
}
