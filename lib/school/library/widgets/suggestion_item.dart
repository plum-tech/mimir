import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

typedef SuggestionItemTap = void Function(String item);

class SuggestionItemView extends StatefulWidget {
  final SuggestionItemTap? onItemTap;
  final List<String> titleItems;
  final int limitLength;

  const SuggestionItemView({
    super.key,
    this.onItemTap,
    this.titleItems = const [],
    this.limitLength = 20,
  });

  @override
  State<SuggestionItemView> createState() => _SuggestionItemViewState();
}

class _SuggestionItemViewState extends State<SuggestionItemView> {
  bool showMore = false;

  Widget buildExpandButton() {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: showMore
            ? [
                const Icon(Icons.expand_less),
                const Text('点击合起'),
              ]
            : [
                const Icon(Icons.expand_more),
                const Text('点击展开'),
              ],
      ),
      onTap: () {
        setState(() {
          showMore = !showMore;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var items = widget.titleItems;
    // 没展开时候显示的数目
    int limitLength = items.length >= widget.limitLength ? widget.limitLength : items.length;
    // 根据情况切片到小于等于指定长度
    items = items.sublist(0, showMore ? items.length : limitLength);

    // 是否应当显示展开按钮
    // 只有当超过限制时才显示
    bool shouldShowExpandButton = widget.titleItems.length > widget.limitLength;
    return Column(
      children: [
        items
            .map((item) {
              return ActionChip(
                label: item.text(),
                onPressed: () {
                  if (widget.onItemTap != null) {
                    widget.onItemTap!(item);
                  }
                },
              );
            })
            .toList()
            .wrap(spacing: 4),
        shouldShowExpandButton ? buildExpandButton() : const SizedBox(),
      ],
    );
  }
}
