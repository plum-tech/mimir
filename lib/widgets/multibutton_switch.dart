import 'package:flutter/material.dart';

typedef SwitchCallback = void Function(int index);

class MultiButtonSwitch extends StatefulWidget {
  final List<Widget> children;
  final SwitchCallback onSwitch;
  final int defaultOptionIndex;

  const MultiButtonSwitch({
    Key? key,
    required this.children,
    required this.onSwitch,
    this.defaultOptionIndex = 0,
  }) : super(key: key);

  @override
  State<MultiButtonSwitch> createState() => _MultiButtonSwitchState();
}

class _MultiButtonSwitchState extends State<MultiButtonSwitch> {
  late int currentOptionIndex;

  @override
  void initState() {
    currentOptionIndex = widget.defaultOptionIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.children.asMap().entries.map((MapEntry<int, Widget> entry) {
        final e = Expanded(
          child: TextButton(
            onPressed: () {
              widget.onSwitch(entry.key);
              setState(() {
                currentOptionIndex = entry.key;
              });
            },
            child: entry.value,
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                if (currentOptionIndex == entry.key) {
                  return Colors.blueAccent;
                }
                return Colors.black;
              }),
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                //设置按下时的背景颜色
                if (currentOptionIndex == entry.key) {
                  return Colors.blue[100];
                }
                //默认不使用背景颜色
                return null;
              }),
            ),
          ),
        );
        return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [e],
          ),
        );
      }).toList(),
    );
  }
}
