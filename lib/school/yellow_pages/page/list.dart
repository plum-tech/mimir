// import 'package:auto_animated/auto_animated.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:mimir/design/animation/livelist.dart';
// import 'package:mimir/design/colors.dart';
// import 'package:rettulf/rettulf.dart';
//
// import '../entity/contact.dart';
// import '../widgets/contact.dart';
//
// class GroupedContactList extends StatefulWidget {
//   final Map<String, List<SchoolContact>> contacts;
//
//   const GroupedContactList(this.contacts, {super.key});
//
//   @override
//   State<GroupedContactList> createState() => _GroupedContactListState();
// }
//
// class _GroupedContactListState extends State<GroupedContactList> {
//   @override
//   Widget build(BuildContext context) {
//     return GroupedListView<SchoolContact, String>(
//       elements: widget.contacts.map((key, value) => value),
//       groupBy: (element) => element.department,
//       useStickyGroupSeparators: true,
//       stickyHeaderBackgroundColor: context.bgColor,
//       order: GroupedListOrder.DESC,
//       // 生成电话列表
//       itemBuilder: (ctx, contact) => ContactTile(contact),
//       groupHeaderBuilder: (SchoolContact c) => ListTile(
//         title: Text(
//           c.department,
//           //style: titleStyle,
//         ),
//       ),
//     );
//   }
// }
//
// class NavigationContactList extends StatefulWidget {
//   final Map<String, SchoolContact> contacts;
//
//   const NavigationContactList(this.contacts, {super.key});
//
//   @override
//   State<StatefulWidget> createState() => _NavigationContactListState();
// }
//
// class _NavigationContactListState extends State<NavigationContactList> {
//   late Map<String, List<SchoolContact>> group2List;
//   String? _selected;
//
//   @override
//   void initState() {
//     super.initState();
//     group2List = widget.contacts.groupListsBy((contact) => contact.department);
//     _selected = group2List.isNotEmpty ? group2List.keys.first : null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return [
//       group2List.keys
//           .map((name) => buildNavigationItem(context, name))
//           .toList()
//           .column()
//           .scrolled()
//           .align(at: Alignment.topCenter)
//           .flexible(flex: 1),
//       const VerticalDivider(width: 0),
//       buildListView(context).flexible(flex: 5)
//     ].row();
//   }
//
//   Widget buildNavigationItem(BuildContext ctx, String name) {
//     return ListTile(title: name.text(), selected: _selected == name, selectedTileColor: context.bgColor).on(tap: () {
//       setState(() {
//         _selected = name;
//       });
//     }).align(at: Alignment.centerLeft);
//   }
//
//   Widget buildListView(BuildContext ctx) {
//     final selected = _selected;
//     if (selected == null) {
//       return const SizedBox();
//     } else {
//       final items = group2List[selected];
//       if (items == null) {
//         return const SizedBox();
//       }
//       return LayoutBuilder(builder: (ctx, constraints) {
//         final count = constraints.maxWidth ~/ 300;
//         return LiveGrid.options(
//           key: ValueKey(selected),
//           itemCount: items.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: count,
//             childAspectRatio: 4,
//           ),
//           options: commonLiveOptions,
//           itemBuilder: (ctx, index, animation) => ContactTile(items[index]).aliveWith(animation),
//         );
//       });
//     }
//   }
// }
