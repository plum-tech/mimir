library multiselect_scope;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Steal from: "https://github.com/flankb/multiselect_scope/blob/master/lib/multiselect_scope.dart"
enum SelectionEvent {
  /// Unselect item if it selected, select otherwise
  auto,

  /// Select item
  select,

  /// Deselect item
  unselect,
}

/// An object that stores the selected indexes and also allows you to change them
class MultiselectController extends ChangeNotifier {
  List<int> _selectedIndexes = [];
  List _dataSource = [];

  List<int> get selectedIndexes => _selectedIndexes;

  bool get selectionAttached => _selectedIndexes.any((element) => true);

  late int _itemsCount;

  /// Select (or unselect) item by index
  /// If passed [event] is [SelectionEvent.auto] function automatically
  /// decide that action will need apply
  void select(int index, {SelectionEvent event = SelectionEvent.auto}) {
    final indexContains = _selectedIndexes.contains(index);
    final computedEvent = event == SelectionEvent.auto
        ? indexContains
            ? SelectionEvent.unselect
            : SelectionEvent.select
        : event;

    if (computedEvent == SelectionEvent.select) {
      if (!indexContains) {
        _selectedIndexes.add(index);
        notifyListeners();
      }
    } else if (computedEvent == SelectionEvent.unselect) {
      if (indexContains) {
        _selectedIndexes.remove(index);
        notifyListeners();
      }
    }
  }

  /// Get current selected items in [dataSource]
  List getSelectedItems() {
    final selectedItems = selectedIndexes.map((e) => _dataSource[e]).toList();
    return selectedItems;
  }

  /// Set all selection to empty
  void clearSelection() {
    if (selectedIndexes.any((element) => true)) {
      selectedIndexes.clear();
      notifyListeners();
    }
  }

  /// Replace selection by all not selected items
  void invertSelection() {
    _selectedIndexes = List<int>.generate(_itemsCount, (i) => i).toSet().difference(_selectedIndexes.toSet()).toList();

    notifyListeners();
  }

  /// Select all items in [dataSource]
  void selectAll() {
    _selectedIndexes = List<int>.generate(_itemsCount, (i) => i);
    notifyListeners();
  }

  /// Check selection of item by it index
  bool isSelected(int index) {
    return _selectedIndexes.contains(index);
  }

  /// Set selection by specified indexes
  /// Replace existing selected indexes by [newIndexes]
  void setSelectedIndexes(List<int> newIndexes) {
    _setSelectedIndexes(newIndexes, true);
  }

  void _setDataSource(List dataSource) {
    _dataSource = dataSource;
    _itemsCount = dataSource.length;
  }

  void _setSelectedIndexes(List<int> newIndexes, bool notifyListeners) {
    _selectedIndexes = newIndexes;

    if (notifyListeners) {
      this.notifyListeners();
    }
  }
}

typedef SelectionChangedCallback<T> = void Function(List<int> selectedIndexes, List<T> selectedItems);

/// Widget to manage item selection
class MultiselectScope<T> extends StatefulWidget {
  /// A child widget that usually contains in its subtree a list
  /// of items whose selection you want to control
  final Widget child;

  /// Function that invoked when selected indexes changes.
  /// Builds appropriate listeners on stage of init [MultiselectScope] widget
  /// and then does not change.
  /// This function will not invoke on first load of this widget.
  final SelectionChangedCallback<T>? onSelectionChanged;

  /// An object that stores the selected indexes and also allows you to change them
  /// This object may be set once and can not be replaced
  /// when updating the widget configuration
  final MultiselectController? controller;

  /// Data for selection tracking
  /// For example list of `Cars` or `Employees`
  final List<T> dataSource;

  /// Clear selection if user push back button
  final bool clearSelectionOnPop;

  /// If [true]: when you update [dataSource] then selected indexes will update
  /// so that the same elements in new [dataSource] are selected
  /// If [false]: selected indexes will have not automatically updates during [dataSource] update
  final bool keepSelectedItemsBetweenUpdates;

  /// Selected indexes, which will be initialized
  /// when the widget is inserted into the widget tree
  final List<int>? initialSelectedIndexes;

  const MultiselectScope({
    super.key,
    required this.dataSource,
    this.controller,
    this.onSelectionChanged,
    this.clearSelectionOnPop = false,
    this.keepSelectedItemsBetweenUpdates = true,
    this.initialSelectedIndexes,
    required this.child,
  });

  @override
  State<MultiselectScope<T>> createState() => _MultiselectScopeState<T>();

  static MultiselectController controllerOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedMultiselectNotifier>()!.controller;
  }
}

class _MultiselectScopeState<T> extends State<MultiselectScope<T>> {
  late List<int> _hashesCopy;
  late MultiselectController _multiselectController;

  void _onSelectionChangedFunc() {
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(
          _multiselectController.selectedIndexes, _multiselectController.getSelectedItems().cast<T>());
    }
  }

  List<int> _createHashesCopy(MultiselectScope widget) {
    return widget.dataSource.map((e) => e.hashCode).toList();
  }

  @override
  void initState() {
    super.initState();

    _multiselectController = widget.controller ?? MultiselectController();

    _hashesCopy = _createHashesCopy(widget);
    _multiselectController._setDataSource(widget.dataSource);

    if (widget.initialSelectedIndexes != null) {
      _multiselectController._setSelectedIndexes(widget.initialSelectedIndexes!, false);
    }

    if (widget.onSelectionChanged != null) {
      _multiselectController.addListener(_onSelectionChangedFunc);
    }
  }

  @override
  void dispose() {
    _multiselectController.removeListener(_onSelectionChangedFunc);
    super.dispose();
  }

  @override
  void didUpdateWidget(MultiselectScope<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('didUpdateWidget GreatMultiselect');

    if (widget.keepSelectedItemsBetweenUpdates) {
      _updateController(oldWidget);
    }

    _multiselectController._setDataSource(widget.dataSource);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build GreatMultiselect');
    return widget.clearSelectionOnPop
        ? WillPopScope(
            onWillPop: () async {
              if (_multiselectController.selectionAttached) {
                _multiselectController.clearSelection();
                return false;
              }

              return true;
            },
            child: _buildMultiselectScope(),
          )
        : _buildMultiselectScope();
  }

  _InheritedMultiselectNotifier _buildMultiselectScope() =>
      _InheritedMultiselectNotifier(controller: _multiselectController, child: widget.child);

  void _updateController(MultiselectScope oldWidget) {
    if (!oldWidget.keepSelectedItemsBetweenUpdates && widget.keepSelectedItemsBetweenUpdates) {
      // Recalculate hashes of previous state
      _hashesCopy = _createHashesCopy(oldWidget);
    }

    final newHashesCopy = _createHashesCopy(widget);

    //debugPrint(
    //    "Old dataSource: ${_hashesCopy} new dataSource: ${newHashesCopy}");
    final oldSelectedHashes = _multiselectController.selectedIndexes.map((e) => _hashesCopy[e]).toList();

    final newIndexes = <int>[];
    newHashesCopy.asMap().forEach((index, value) {
      //debugPrint("$index $value");
      if (oldSelectedHashes.contains(value)) {
        newIndexes.add(index);
      }
    });

    _multiselectController._setSelectedIndexes(newIndexes, false);
    _hashesCopy = newHashesCopy;
  }
}

class _InheritedMultiselectNotifier extends InheritedNotifier<MultiselectController> {
  final MultiselectController controller;

  const _InheritedMultiselectNotifier({Key? key, required Widget child, required this.controller})
      : super(key: key, child: child, notifier: controller);
}
