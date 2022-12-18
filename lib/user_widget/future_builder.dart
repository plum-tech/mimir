import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mimir/design/user_widgets/placeholder.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef MyWidgetBuilder<T> = Widget Function(BuildContext context, T data);
typedef MyErrorWidgetBuilder = Widget? Function(
  BuildContext context,
  MyFutureBuilder futureBuilder,
  dynamic error,
  dynamic stackTrace,
);

class MyFutureBuilderController<T> {
  late _MyFutureBuilderState<T> _state;
  void _bindState(State<MyFutureBuilder<T>> state) => _state = state as _MyFutureBuilderState<T>;

  Future<T> refresh() => _state.refresh();
}

class MyFutureBuilder<T> extends StatefulWidget {
  // 全局错误处理
  static MyErrorWidgetBuilder? globalErrorBuilder;

  final Future<T>? future;
  final MyWidgetBuilder<T>? builder;
  final MyErrorWidgetBuilder? onErrorBuilder;
  final MyFutureBuilderController? controller;

  /// 建议使用该参数代替future, 否则可能无法正常实现刷新功能
  final Future<T> Function()? futureGetter;

  /// 刷新之前回调
  final Future<void> Function()? onPreRefresh;

  /// 刷新后回调
  final Future<void> Function()? onPostRefresh;

  /// 是否启用下拉刷新
  final bool enablePullRefresh;

  const MyFutureBuilder({
    super.key,
    this.future,
    required this.builder,
    this.onErrorBuilder,
    this.controller,
    this.enablePullRefresh = false,
    this.onPreRefresh,
    this.onPostRefresh,
    this.futureGetter,
  });

  @override
  State<MyFutureBuilder<T>> createState() => _MyFutureBuilderState<T>();
}

class _MyFutureBuilderState<T> extends State<MyFutureBuilder<T>> {
  Completer<T> completer = Completer();

  Future<T> refresh() {
    setState(() {});
    return completer.future;
  }

  Widget buildWhenSuccessful(T? data) {
    if (!completer.isCompleted) completer.complete(data);
    return widget.builder == null ? Text(data.toString()) : widget.builder!(context, data as T);
  }

  Widget buildWhenError(error, stackTrace) {
    if (!completer.isCompleted) {
      completer.completeError(error, stackTrace);
    }
    // 判定是否有单独处理
    if (widget.onErrorBuilder != null) {
      final r = widget.onErrorBuilder!(context, widget, error, stackTrace);
      if (r != null) return r;
    }

    // 判定是否有全局处理
    if (MyFutureBuilder.globalErrorBuilder != null) {
      final r = MyFutureBuilder.globalErrorBuilder!(context, widget, error, stackTrace);
      if (r != null) return r;
    }

    // 默认处理
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(error.toString()),
          ],
        ),
      ),
    );
  }

  Widget buildWhenOther(AsyncSnapshot<T> snapshot) {
    if (!completer.isCompleted) completer.complete();
    throw Exception('snapshot has no data or error');
  }

  Widget buildWhenLoading() {
    return Placeholders.loading();
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
    throw UnsupportedError('MyFutureBuilder must set a future or futureGetter');
  }

  Widget buildFutureBuilder() {
    return FutureBuilder<T>(
      key: UniqueKey(),
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return buildWhenSuccessful(snapshot.data);
          } else if (snapshot.hasError) {
            return buildWhenError(snapshot.error, snapshot.stackTrace);
          } else {
            return buildWhenOther(snapshot);
          }
        }
        return buildWhenLoading();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result = buildFutureBuilder();

    RefreshController refreshController = RefreshController();
    if (widget.enablePullRefresh) {
      result = SmartRefresher(
        controller: refreshController,
        onRefresh: () async {
          try {
            completer = Completer();
            if (widget.onPreRefresh != null) await widget.onPreRefresh!();
            await refresh();
            if (widget.onPostRefresh != null) await widget.onPostRefresh!();
          } finally {
            refreshController.refreshCompleted();
          }
        },
        child: result,
      );
    }
    return result;
  }

  @override
  void initState() {
    widget.controller?._bindState(this);
    super.initState();
  }
}
