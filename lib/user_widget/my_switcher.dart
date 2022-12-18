import 'package:flutter/material.dart';

class MySwitcher extends StatefulWidget {
  final bool initialState;
  final ValueChanged<bool>? onChanged;

  const MySwitcher(this.initialState, {this.onChanged, Key? key}) : super(key: key);

  @override
  State<MySwitcher> createState() => _MySwitcherState();
}

class _MySwitcherState extends State<MySwitcher> {
  late bool state;

  @override
  void initState() {
    state = widget.initialState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: Colors.green,
      value: state,
      onChanged: (value) {
        setState(() {
          state = value;
          if (widget.onChanged != null) {
            widget.onChanged!(state);
          }
        });
      },
    );
  }
}
