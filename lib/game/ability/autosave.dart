import 'ability.dart';

class AutoSaveWidgetAbility extends GameWidgetAbility {
  final void Function() onSave;

  const AutoSaveWidgetAbility({required this.onSave});

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
