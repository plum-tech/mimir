import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NoteNumberButton extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const NoteNumberButton({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      icon: Icon(enabled ? Icons.note_alt : Icons.note_alt_outlined),
      onPressed: () {
        onChanged(!enabled);
      },
    );
  }
}

class ClearNumberButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ClearNumberButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      icon: Icon(Icons.delete),
      onPressed: onTap,
    );
  }
}

class HintButton extends StatelessWidget {
  final VoidCallback? onTap;

  const HintButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      icon: Icon(Icons.lightbulb),
      onPressed: onTap,
    );
  }
}
