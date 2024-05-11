library ability;

import 'package:flutter/cupertino.dart';

abstract class GameWidgetAbility {
  const GameWidgetAbility();

  void initState() {}

  void deactivate() {}

  void dispose() {}

  void onAppInactive() {}

  void onAppResumed() {}
}

mixin GameWidgetAbilityMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
  late final List<GameWidgetAbility> abilities;

  /// This will be called in [initState].
  List<GameWidgetAbility> createAbility();

  @override
  void initState() {
    super.initState();
    abilities = createAbility();
    for (final ability in abilities) {
      ability.initState();
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (final ability in abilities) {
      ability.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      for (final ability in abilities) {
        ability.onAppInactive();
      }
    } else if (state == AppLifecycleState.resumed) {
      for (final ability in abilities) {
        ability.onAppResumed();
      }
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void deactivate() {
    for (final ability in abilities) {
      ability.deactivate();
    }
    super.deactivate();
  }
}
