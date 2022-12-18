import 'dart:async';

import 'package:flutter/material.dart';

enum FutureState { loading, failed, end }

typedef PlaceholderWidgetBuilder<T> = Widget Function(BuildContext context, T? data, FutureState state);

class PlaceholderBuilderController<T> {
  late _PlaceholderFutureBuilderState<T> _state;

  void _bindState(State<PlaceholderFutureBuilder<T>> state) => _state = state as _PlaceholderFutureBuilderState<T>;

  Future<T> refresh() => _state.refresh();
}

class PlaceholderFutureBuilder<T> extends StatefulWidget {
  final Future<T>? future;
  final PlaceholderWidgetBuilder<T> builder;
  final PlaceholderBuilderController? controller;

  final Future<T> Function()? futureGetter;

  const PlaceholderFutureBuilder({
    super.key,
    this.future,
    required this.builder,
    this.controller,
    this.futureGetter,
  });

  @override
  State<PlaceholderFutureBuilder<T>> createState() => _PlaceholderFutureBuilderState<T>();
}

class _PlaceholderFutureBuilderState<T> extends State<PlaceholderFutureBuilder<T>> {
  Completer<T> completer = Completer();

  @override
  void initState() {
    widget.controller?._bindState(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      key: UniqueKey(),
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return widget.builder(context, snapshot.data, FutureState.end);
          } else if (snapshot.hasError) {
            return widget.builder(context, null, FutureState.failed);
          } else {
            if (!completer.isCompleted) completer.complete();
            throw Exception('snapshot has no data or error');
          }
        }
        return widget.builder(context, null, FutureState.loading);
      },
    );
  }

  Future<T> refresh() {
    setState(() {});
    return completer.future;
  }

  Future<T> fetchData() async {
    var getter = widget.futureGetter;
    if (getter != null) {
      return await getter();
    }
    var future = widget.future;
    if (future != null) {
      return await future;
    }
    throw UnsupportedError('PlaceholderFutureBuilder requires a Future or FutureGetter');
  }
}
