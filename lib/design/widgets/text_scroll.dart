/*
From https://github.com/yurii-khi/text_scroll

Copyright 2022 yurii-khi.com
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import 'dart:async';

import 'package:flutter/material.dart';

/// TextScroll widget automatically scrolls provided [text] according
/// to custom settings, in order to achieve 'marquee' text effect.
///
/// ### Example:
///
/// ```dart
/// TextScroll(
///     'This is the sample text for Flutter TextScroll widget. ',
///     mode: TextScrollMode.bouncing,
///     velocity: Velocity(pixelsPerSecond: Offset(150, 0)),
///     delayBefore: Duration(milliseconds: 500),
///     numberOfReps: 5,
///     pauseBetween: Duration(milliseconds: 50),
///     style: TextStyle(color: Colors.green),
///     textAlign: TextAlign.right,
///     selectable: true,
/// )
/// ```
class TextScroll extends StatefulWidget {
  const TextScroll(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.textDirection = TextDirection.ltr,
    this.numberOfReps,
    this.delayBefore,
    this.pauseBetween,
    this.pauseOnBounce,
    this.mode = TextScrollMode.endless,
    this.velocity = const Velocity(pixelsPerSecond: Offset(80, 0)),
    this.selectable = false,
    this.intervalSpaces,
    this.fadedBorder = false,
    this.fadedBorderWidth = 0.2,
    this.fadeBorderSide = FadeBorderSide.both,
    this.fadeBorderVisibility = FadeBorderVisibility.auto,
  }) : super(key: key);

  /// The text string, that would be scrolled.
  /// In case text does fit into allocated space, it wouldn't be scrolled
  /// and would be shown as is.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// TextScroll('This is the sample text for Flutter TextScroll widget.')
  /// ```
  final String text;

  /// Provides [TextAlign] alignment if text string is not long enough to be scrolled.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'Short string',
  ///   textAlign: TextAlign.right,
  /// )
  /// ```
  final TextAlign? textAlign;

  /// Provides [TextDirection] - a direction in which text flows.
  /// Default is [TextDirection.ltr].
  /// Default scrolling direction would be opposite to [textDirection],
  /// e.g. for [TextDirection.rtl] scrolling would be from left to right
  ///
  /// ### Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'Hey! I\'m a RTL text, check me out. Hey! I\'m a RTL text, check me out. Hey! I\'m a RTL text, check me out. ',
  ///   textDirection: TextDirection.rtl,
  /// )
  /// ```
  final TextDirection textDirection;

  /// Allows to apply custom [TextStyle] to [text].
  ///
  /// `null` by default.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'Styled text',
  ///   style: TextStyle(
  ///     color: Colors.red,
  ///   ),
  /// )
  /// ```
  final TextStyle? style;

  /// Limits number of scroll animation rounds.
  ///
  /// Default is [infinity].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'Limit scroll rounds to 10',
  ///   numberOfReps: 10,
  /// )
  /// ```
  final int? numberOfReps;

  /// Delay before first animation round.
  ///
  /// Default is [Duration.zero].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'Start animation after 1 sec delay',
  ///   delayBefore: Duration(seconds: 1),
  /// )
  /// ```
  final Duration? delayBefore;

  /// Determines pause interval between animation rounds.
  ///
  /// Default is [Duration.zero].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'Pause animation between rounds',
  ///   mode: TextScrollMode.bouncing,
  ///   pauseBetween: Duration(milliseconds: 300),
  /// )
  /// ```
  final Duration? pauseBetween;

  /// Determines pause interval before changing direction on a bounce.
  ///
  /// Default is [Duration.zero].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'Pause animation when text reaches the end',
  ///   mode: TextScrollMode.bouncing,
  ///   pauseOnBounce: Duration(milliseconds: 300),
  /// )
  /// ```
  final Duration? pauseOnBounce;

  /// Sets one of two different types of scrolling behavior.
  ///
  /// [TextScrollMode.endless] - default, scrolls text in one direction endlessly.
  ///
  /// [TextScrollMode.bouncing] - when [text] string is scrolled to its end,
  /// starts animation to opposite direction.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'Animate text string back and forth',
  ///   mode: TextScrollMode.bouncing,
  /// )
  /// ```
  final TextScrollMode mode;

  /// Allows to customize animation speed.
  ///
  /// Default is `Velocity(pixelsPerSecond: Offset(80, 0))`
  ///
  /// ### Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'Animate text at 200px per second',
  ///   velocity: Velocity(pixelsPerSecond: Offset(200, 0)),
  /// )
  final Velocity velocity;

  /// Allows users to select provided [text], copy it to clipboard etc.
  ///
  /// Default is `false`.
  ///
  /// Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'Selectable text',
  ///   selectable: true,
  /// )
  /// ```
  final bool selectable;

  /// Adds blank spaces between two nearby text sentences
  /// in case of [TextScrollMode.endless]
  ///
  /// Default is `1`.
  ///
  /// Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'This is the sample text for Flutter TextScroll widget. ',
  ///   blankSpaces: 10,
  /// )
  /// ```
  final int? intervalSpaces;

  /// Fades the text out to the left and right edges of the widget.
  /// Default is `false`.
  ///
  /// Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'This is the sample text for Flutter TextScroll widget. ',
  ///   fadedBorder: true,
  /// )
  /// ```
  final bool fadedBorder;

  /// Sets width of the faded border.
  /// Default is `0.2`.
  ///
  /// Example:
  ///
  /// ```dart
  /// TextScroll(
  ///   'This is the sample text for Flutter TextScroll widget. ',
  ///   fadedBorder: true,
  ///   fadedBorderWidth: 0.25,
  /// )
  /// ```
  final double? fadedBorderWidth;

  /// Sets which side of the widget should be faded.
  /// Default is [FadeBorderSide.both].
  ///
  /// Example:
  ///
  /// ```dart
  /// TextScroll(
  ///  'This is the sample text for Flutter TextScroll widget. ',
  ///  fadedBorder: true,
  ///  fadeBorderSide: FadeBorderSide.left,
  ///  )
  ///  ```
  final FadeBorderSide fadeBorderSide;

  /// Sets when the fadeBorder should be shown.
  /// Default is [FadeBorderSide.auto].
  ///
  /// Example:
  ///
  /// ```dart
  /// TextScroll(
  ///  'This is the sample text for Flutter TextScroll widget. ',
  ///  fadedBorder: true,
  ///  fadeBorderVisibility: FadeBorderVisibility.always,
  ///  )
  ///  ```
  final FadeBorderVisibility fadeBorderVisibility;

  @override
  State<TextScroll> createState() => _TextScrollState();
}

class _TextScrollState extends State<TextScroll> {
  final _scrollController = ScrollController();
  String? _endlessText;
  double? _originalTextWidth;
  double _textMinWidth = 0;
  Timer? _timer;
  bool _running = false;
  int _counter = 0;

  @override
  void initState() {
    super.initState();

    final WidgetsBinding? binding = WidgetsBinding.instance;
    if (binding != null) {
      binding.addPostFrameCallback(_initScroller);
    }
  }

  @override
  void didUpdateWidget(covariant TextScroll oldWidget) {
    _onUpdate(oldWidget);

    ///Update timer to adapt to changes in [widget.velocity]
    _setTimer();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.intervalSpaces == null || widget.mode == TextScrollMode.endless,
        'intervalSpaces is only available in TextScrollMode.endless mode');
    assert(
        !widget.fadedBorder ||
            (widget.fadedBorder &&
                widget.fadedBorderWidth != null &&
                widget.fadedBorderWidth! > 0 &&
                widget.fadedBorderWidth! <= 1),
        'fadedBorderInterval must be between 0 and 1 when fadedBorder is true');

    Widget baseWidget = Directionality(
      textDirection: widget.textDirection,
      child: SingleChildScrollView(
          controller: _scrollController,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: _textMinWidth,
            ),
            child: widget.selectable
                ? SelectableText(
                    _endlessText ?? widget.text,
                    style: widget.style,
                    textAlign: widget.textAlign,
                  )
                : Text(
                    _endlessText ?? widget.text,
                    style: widget.style,
                    textAlign: widget.textAlign,
                  ),
          )),
    );

    /// Used to add the fade border effect, if enabled
    Widget? fadeBorderWidget;

    /// If fade border is enabled
    if (widget.fadedBorder) {
      ///Fill list with amount of transparent colors to make the text visible
      final List<Color> colors = List.generate(1 ~/ widget.fadedBorderWidth! - 1, (index) {
        return Colors.transparent;
      }, growable: true);

      ///Add black color to add gradient fade out
      if (widget.fadeBorderSide == FadeBorderSide.both || widget.fadeBorderSide == FadeBorderSide.left) {
        colors.insert(0, Colors.black);
      } else {
        colors.add(Colors.transparent);
      }
      if (widget.fadeBorderSide == FadeBorderSide.both || widget.fadeBorderSide == FadeBorderSide.right) {
        colors.add(Colors.black);
      } else {
        colors.add(Colors.transparent);
      }

      ///Calculate the stops for the gradient
      final List<double> stops = List.generate(1 ~/ widget.fadedBorderWidth!, (index) {
        return (index + 1) * widget.fadedBorderWidth!;
      }, growable: true);

      ///Add first stop to list
      stops.insert(0, 0);

      /// Pre-render text to get it's width
      final TextPainter textPrototype = TextPainter(
        text: TextSpan(
          text: _endlessText ?? widget.text,
          style: widget.style,
        ),
        textDirection: widget.textDirection,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textWidthBasis: TextWidthBasis.longestLine,
      )..layout();

      ///Apply ShaderMask to the text
      fadeBorderWidget = LayoutBuilder(
        builder: (context, constraints) {
          ///When text is wider than the widget, apply ShaderMask
          if (widget.fadeBorderVisibility == FadeBorderVisibility.always ||
              constraints.maxWidth < textPrototype.size.width) {
            return ShaderMask(
              blendMode: BlendMode.dstOut,
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: colors,
                  stops: stops,
                ).createShader(rect);
              },
              child: baseWidget,
            );
          } else {
            ///When text is smaller than the widget, just return the text
            return baseWidget;
          }
        },
      );
    }

    return fadeBorderWidget ?? baseWidget;
  }

  Future<void> _initScroller(_) async {
    setState(() {
      _textMinWidth = _scrollController.position.viewportDimension;
    });

    await _delayBefore();
    _setTimer();
  }

  /// Sets [_timer] for animation
  void _setTimer() {
    ///Cancel previous timer if it exists
    _timer?.cancel();

    ///Reset [_running] to allow for updates on changed velocity
    _running = false;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_available) {
        timer.cancel();
        return;
      }
      final int? maxReps = widget.numberOfReps;
      if (maxReps != null && _counter >= maxReps) {
        timer.cancel();
        return;
      }

      if (!_running) _run();
    });
  }

  Future<void> _run() async {
    _running = true;

    final int? maxReps = widget.numberOfReps;
    if (maxReps == null || _counter < maxReps) {
      _counter++;

      switch (widget.mode) {
        case TextScrollMode.bouncing:
          {
            await _animateBouncing();
            break;
          }
        default:
          {
            await _animateEndless();
          }
      }
    }
    _running = false;
  }

  Future<void> _animateEndless() async {
    if (!_available) return;

    final ScrollPosition position = _scrollController.position;
    final bool needsScrolling = position.maxScrollExtent > 0;
    if (!needsScrolling) {
      if (_endlessText != null) setState(() => _endlessText = null);
      return;
    }

    if (_endlessText == null || _originalTextWidth == null) {
      setState(() {
        _originalTextWidth = position.maxScrollExtent + position.viewportDimension;
        _endlessText = widget.text + _getSpaces(widget.intervalSpaces ?? 1) + widget.text;
      });

      return;
    }

    final double endlessTextWidth = position.maxScrollExtent + position.viewportDimension;
    final double singleRoundExtent = endlessTextWidth - _originalTextWidth!;
    final Duration duration = _getDuration(singleRoundExtent);
    if (duration == Duration.zero) return;

    if (!_available) return;
    await _scrollController.animateTo(
      singleRoundExtent,
      duration: duration,
      curve: Curves.linear,
    );
    if (!_available) return;
    _scrollController.jumpTo(position.minScrollExtent);

    ///Pause between animation rounds
    if (widget.pauseBetween != null) {
      await Future.delayed(widget.pauseBetween!);
    }
  }

  Future<void> _animateBouncing() async {
    final double maxExtent = _scrollController.position.maxScrollExtent;
    final double minExtent = _scrollController.position.minScrollExtent;
    final double extent = maxExtent - minExtent;
    final Duration duration = _getDuration(extent);
    if (duration == Duration.zero) return;

    if (!_available) return;
    await _scrollController.animateTo(
      maxExtent,
      duration: duration,
      curve: Curves.linear,
    );
    if (widget.pauseOnBounce != null) {
      await Future.delayed(widget.pauseOnBounce!);
    }
    if (!_available) return;
    await _scrollController.animateTo(
      minExtent,
      duration: duration,
      curve: Curves.linear,
    );
    if (!_available) return;
    if (widget.pauseBetween != null) {
      await Future<dynamic>.delayed(widget.pauseBetween!);
    }
  }

  Future<void> _delayBefore() async {
    final Duration? delayBefore = widget.delayBefore;
    if (delayBefore == null) return;

    await Future<dynamic>.delayed(delayBefore);
  }

  Duration _getDuration(double extent) {
    ///No movement when velocity offset dx equals 0
    if (widget.velocity.pixelsPerSecond.dx == 0) return Duration.zero;

    final int milliseconds = (extent * 1000 / widget.velocity.pixelsPerSecond.dx).round();

    return Duration(milliseconds: milliseconds);
  }

  void _onUpdate(TextScroll oldWidget) {
    if (widget.text != oldWidget.text && _endlessText != null) {
      setState(() {
        _endlessText = null;
        _originalTextWidth = null;
      });
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  String _getSpaces(int number) {
    String spaces = '';
    for (int i = 0; i < number; i++) {
      spaces += '\u{00A0}';
    }

    return spaces;
  }

  bool get _available => mounted && _scrollController.hasClients;
}

/// Animation types for [TextScroll] widget.
///
/// [endless] - scrolls text in one direction endlessly.
///
/// [bouncing] - when text is scrolled to its end,
/// starts animation to opposite direction.
enum TextScrollMode {
  bouncing,
  endless,
}

/// Side of the text border to fade out.
///
/// [left] - fade out left side of the text.
/// [right] - fade out right side of the text.
/// [both] - fade out both sides of the text.
enum FadeBorderSide { left, right, both }

/// Sets when the fade border will be applied
///
/// [always] - always show the border, independent of the text length
/// [auto] - show the border only when the text is wider than the widget
enum FadeBorderVisibility { always, auto }
