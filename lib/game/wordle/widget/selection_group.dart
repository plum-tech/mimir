import 'package:flutter/material.dart';
import 'group_shared.dart';

class SelectionGroupProvider extends StatefulWidget {
  const SelectionGroupProvider({
    super.key,
    required this.selections,
    required this.onChanged,
    this.defaultSelection = 0,
  });

  final Widget selections;
  final int defaultSelection;
  final void Function(int) onChanged;

  @override
  State<SelectionGroupProvider> createState() => _SelectionGroupProviderState();
}

class _SelectionGroupProviderState extends State<SelectionGroupProvider> {
  int selected = 0;

  @override
  void initState() {
    super.initState();
    selected = widget.defaultSelection;
  }

  @override
  Widget build(BuildContext context) {
    return GroupSharedData(
      selected: selected,
      child: NotificationListener<SelectNotification>(
        child: widget.selections,
        onNotification: (noti) {
          setState(() {
            selected = noti.selection;
            widget.onChanged(selected);
          });
          return true;
        },
      ),
    );
  }
}