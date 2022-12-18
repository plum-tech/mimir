import 'package:flutter/widgets.dart';
// steal from "https://github.com/QuirijnGB/lazy-load-scrollview"

// ignore: constant_identifier_names
enum LoadingStatus { LOADING, STABLE }

/// Signature for EndOfPageListeners
typedef EndOfPageListenerCallback = void Function();

/// A widget that wraps a [Widget] and will trigger [onEndOfPage] when it
/// reaches the bottom of the list
class LazyColumn extends StatefulWidget {
  /// The [Widget] that this widget watches for changes on
  final Widget child;

  /// Called when the [child] reaches the end of the list
  final EndOfPageListenerCallback onEndOfPage;

  /// The offset to take into account when triggering [onEndOfPage] in pixels
  final int scrollOffset;

  /// Used to determine if loading of new data has finished. You should use set this if you aren't using a FutureBuilder or StreamBuilder
  final bool isLoading;

  /// Prevented update nested listview with other axis direction
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() => LazyColumnState();

  const LazyColumn({
    super.key,
    required this.child,
    required this.onEndOfPage,
    this.scrollDirection = Axis.vertical,
    this.isLoading = false,
    this.scrollOffset = 100,
  });
}

class LazyColumnState extends State<LazyColumn> {
  LoadingStatus loadMoreStatus = LoadingStatus.STABLE;

  @override
  void didUpdateWidget(LazyColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading) {
      loadMoreStatus = LoadingStatus.STABLE;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: widget.child,
      onNotification: (notification) => _onNotification(notification, context),
    );
  }

  bool _onNotification(ScrollNotification notification, BuildContext context) {
    if (widget.scrollDirection == notification.metrics.axis) {
      if (notification is ScrollUpdateNotification) {
        if (notification.metrics.maxScrollExtent > notification.metrics.pixels &&
            notification.metrics.maxScrollExtent - notification.metrics.pixels <= widget.scrollOffset) {
          _loadMore();
        }
        return true;
      }

      if (notification is OverscrollNotification) {
        if (notification.overscroll > 0) {
          _loadMore();
        }
        return true;
      }
    }
    return false;
  }

  void _loadMore() {
    if (loadMoreStatus == LoadingStatus.STABLE) {
      loadMoreStatus = LoadingStatus.LOADING;
      widget.onEndOfPage();
    }
  }
}
