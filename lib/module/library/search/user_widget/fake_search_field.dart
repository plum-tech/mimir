import 'package:flutter/material.dart';

/// 构造了一个假的文本输入框组件
class FakeSearchField extends StatefulWidget {
  final GestureTapCallback? onTap;
  final String suggestion;

  const FakeSearchField({
    Key? key,
    this.onTap,
    this.suggestion = '',
  }) : super(key: key);

  @override
  _FakeSearchFieldState createState() => _FakeSearchFieldState();
}

class _FakeSearchFieldState extends State<FakeSearchField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          prefixIcon: const Icon(
            Icons.search,
            size: 35,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
