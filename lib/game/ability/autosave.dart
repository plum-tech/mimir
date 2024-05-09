import 'ability.dart';

class AutoSaveAbility extends GameAbility {
  final void Function() onSave;

  const AutoSaveAbility({required this.onSave});

  @override
  void onAppInactive() {
    super.onAppInactive();
    // Save current state when the app becomes inactive
    onSave();
  }

  @override
  void deactivate() {
    onSave();
    super.deactivate();
  }
}
