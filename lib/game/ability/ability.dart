library ability;

import 'package:flutter/cupertino.dart';

abstract class GameAbility {
  const GameAbility();

  void initState() {}

  void deactivate() {}

  void dispose() {}

  void onAppInactive() {}

  void onAppResumed() {}
}

mixin GameAbilityMixin on State, WidgetsBindingObserver {
  late final List<GameAbility> abilities;

  /// This will be called in [initState].
  List<GameAbility> createAbility();

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
    for (final ability in abilities) {
      if (state == AppLifecycleState.inactive) {
        ability.onAppInactive();
      } else if (state == AppLifecycleState.resumed) {
        ability.onAppResumed();
      }
    }

    super.didChangeAppLifecycleState(state);
  }
}
