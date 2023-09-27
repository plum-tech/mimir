import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rettulf/rettulf.dart';

import 'multiplatform.dart';

const _kDialogAlpha = 0.89;

extension $BuildContextEx$ on BuildContext {
  Future<T?> show$Dialog$<T>({
    required WidgetBuilder make,
    bool dismissible = true,
  }) async {
    if (isCupertino) {
      return await showCupertinoDialog<T>(
        context: this,
        builder: make,
        barrierDismissible: dismissible,
      );
    } else {
      return await showDialog<T>(
        context: this,
        builder: make,
        barrierDismissible: dismissible,
      );
    }
  }
}

class $Button$ extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const $Button$({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isCupertino) {
      return CupertinoButton(onPressed: onPressed, child: text.text());
    } else {
      return FilledButton(onPressed: onPressed, child: text.text());
    }
  }
}

class $Action$ {
  final String text;
  final bool isDefault;
  final bool warning;
  final VoidCallback? onPressed;

  const $Action$({
    required this.text,
    this.onPressed,
    this.isDefault = false,
    this.warning = false,
  });
}

class $Dialog$ extends StatelessWidget {
  final String? title;
  final $Action$ primary;
  final $Action$? secondary;

  /// Highlight the title
  final bool serious;
  final WidgetBuilder make;

  const $Dialog$({
    super.key,
    this.title,
    required this.primary,
    required this.make,
    this.secondary,
    this.serious = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget dialog;
    final second = secondary;
    if (isCupertino) {
      dialog = CupertinoAlertDialog(
        title: title?.text(style: TextStyle(fontWeight: FontWeight.w600, color: serious ? context.$red$ : null)),
        content: make(context),
        actions: [
          if (second != null)
            CupertinoDialogAction(
              isDestructiveAction: second.warning,
              isDefaultAction: second.isDefault,
              onPressed: () {
                second.onPressed?.call();
              },
              child: second.text.text(),
            ),
          CupertinoDialogAction(
            isDestructiveAction: primary.warning,
            isDefaultAction: primary.isDefault,
            onPressed: () {
              primary.onPressed?.call();
            },
            child: primary.text.text(),
          )
        ],
      );
    } else {
      // For other platform
      dialog = AlertDialog(
        backgroundColor: context.theme.dialogBackgroundColor.withOpacity(_kDialogAlpha),
        title: title?.text(style: TextStyle(fontWeight: FontWeight.w600, color: serious ? context.$red$ : null)),
        content: make(context),
        actions: [
          CupertinoButton(
              onPressed: () {
                primary.onPressed?.call();
              },
              child: primary.text.text(
                style: TextStyle(
                  color: primary.warning ? context.$red$ : null,
                  fontWeight: primary.isDefault ? FontWeight.w600 : null,
                ),
              )),
          if (second != null)
            CupertinoButton(
              onPressed: () {
                second.onPressed?.call();
              },
              child: second.text.text(
                style: TextStyle(
                  color: second.warning ? context.$red$ : null,
                  fontWeight: second.isDefault ? FontWeight.w600 : null,
                ),
              ),
            )
        ],
        actionsAlignment: MainAxisAlignment.spaceEvenly,
      );
    }
    return dialog;
  }
}

class $ListTile$ extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final FutureOr<void> Function()? onTap;

  const $ListTile$({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isCupertino) {
      return CupertinoListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
      );
    } else {
      return ListTile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
      );
    }
  }
}

class $TextField$ extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autofocus;

  /// On Cupertino, it's a candidate of placeholder.
  /// On Material, it's the [InputDecoration.labelText]
  final String? labelText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmit;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const $TextField$({
    super.key,
    this.controller,
    this.autofocus = false,
    this.placeholder,
    this.labelText,
    this.autofillHints,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmit,
    this.maxLines,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isCupertino) {
      return CupertinoTextField(
          controller: controller,
          autofocus: autofocus,
          placeholder: placeholder ?? labelText,
          textInputAction: textInputAction,
          prefix: prefixIcon,
          suffix: suffixIcon,
          autofillHints: autofillHints,
          onSubmitted: onSubmit,
          maxLines: maxLines,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: const BoxDecoration(
            color: CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.white,
              darkColor: CupertinoColors.darkBackgroundGray,
            ),
            border: _kDefaultRoundedBorder,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          style: CupertinoTheme.of(context).textTheme.textStyle);
    } else {
      return TextFormField(
        controller: controller,
        autofocus: autofocus,
        textInputAction: textInputAction,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: placeholder,
          icon: prefixIcon,
          labelText: labelText,
          suffixIcon: suffixIcon,
        ),
        onFieldSubmitted: onSubmit,
      );
    }
  }
}

const BorderSide _kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0xAAA0A0A0),
  ),
  width: 1.0,
);
const Border _kDefaultRoundedBorder = Border(
  top: _kDefaultRoundedBorderSide,
  bottom: _kDefaultRoundedBorderSide,
  left: _kDefaultRoundedBorderSide,
  right: _kDefaultRoundedBorderSide,
);

extension ColorEx on BuildContext {
  Color get $red$ => isCupertino ? CupertinoDynamicColor.resolve(CupertinoColors.systemRed, this) : Colors.redAccent;
}
