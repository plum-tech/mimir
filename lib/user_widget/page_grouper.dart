import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

// steal from "https://github.com/Akifcan/flutter_pagination"
class PageGrouper extends StatefulWidget {
  final SkipBtnStyle preBtnStyles;
  final PageBtnStyles paginateButtonStyles;
  final bool useSkipButton;
  final int currentPageIndex;
  final int totalPage;
  final int btnPerGroup;
  final double? width;
  final double? height;
  final Function(int number) onPageChange;

  const PageGrouper(
      {Key? key,
      this.width,
      this.height,
      this.useSkipButton = true,
      required this.preBtnStyles,
      required this.paginateButtonStyles,
      required this.onPageChange,
      required this.totalPage,
      required this.btnPerGroup,
      required this.currentPageIndex})
      : super(key: key);

  @override
  State<PageGrouper> createState() => _PageGrouperState();
}

class _PageGrouperState extends State<PageGrouper> {
  late PageController pageController;
  List<List<int>> groupedPages = [];
  double defaultHeight = 50;

  void groupPageBtn() {
    final btnPerGroup = min(widget.btnPerGroup, widget.totalPage);
    List<int> curGroup = [];
    setState(() {
      groupedPages = [];

      for (int i = 0; i < widget.totalPage; i++) {
        curGroup.add(i);
        if (curGroup.length >= btnPerGroup) {
          groupedPages.add(curGroup);
          curGroup = [];
        }
      }
      if (curGroup.isNotEmpty) {
        groupedPages.add(curGroup);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    groupPageBtn();
    pageController = PageController();
    return buildGroupedChild(context);
  }

  Widget buildGroupedChild(BuildContext ctx) {
    return [
      if (widget.useSkipButton)
        _SkipBtn(
          buttonStyles: widget.preBtnStyles,
          height: widget.height ?? defaultHeight,
          onTap: () {
            pageController.previousPage(
                duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
          },
          isPre: true,
        ),
      PageView.builder(
          controller: pageController,
          itemCount: groupedPages.where((element) => element.isNotEmpty).length,
          itemBuilder: (_, index) {
            return Row(
              children: groupedPages[index].map((e) {
                return _PageBtn(
                    active: widget.currentPageIndex == e + 1,
                    buttonStyles: widget.paginateButtonStyles,
                    height: widget.height ?? defaultHeight,
                    page: e + 1,
                    color: e + 1 == widget.currentPageIndex ? Colors.blueGrey : Colors.blue,
                    onTap: (number) {
                      widget.onPageChange(number);
                    }).expanded();
              }).toList(),
            );
          }).expanded(),
      if (widget.useSkipButton)
        _SkipBtn(
          buttonStyles: widget.preBtnStyles.symmetricL2R(),
          height: widget.height ?? defaultHeight,
          onTap: () {
            pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
          },
          isPre: false,
        ),
    ].row().sized(
          w: widget.width ?? ctx.mediaQuery.size.width,
          h: 60,
        );
  }
}

class _SkipBtn extends StatelessWidget {
  final SkipBtnStyle buttonStyles;
  final double height;
  final bool isPre;
  final VoidCallback onTap;

  const _SkipBtn({Key? key, required this.buttonStyles, required this.height, required this.isPre, required this.onTap})
      : super(key: key);

  final double radius = 20;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: buttonStyles.borderRadius ?? BorderRadius.circular(0),
      child: Material(
        color: context.theme.colorScheme.background,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isPre
                ? buttonStyles.icon ?? const Icon(Icons.chevron_left, size: 35)
                : buttonStyles.icon ?? const Icon(Icons.chevron_right, size: 35),
          ),
        ),
      ),
    ).sized(h: height);
  }
}

class _PageBtn extends StatelessWidget {
  final bool active;
  final double height;
  final int page;
  final Color color;
  final Function(int number) onTap;
  final PageBtnStyles buttonStyles;

  const _PageBtn(
      {Key? key,
      required this.active,
      required this.buttonStyles,
      required this.page,
      required this.height,
      required this.color,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: buttonStyles.borderRadius ?? BorderRadius.circular(0),
      child: Material(
        color: active ? context.theme.secondaryHeaderColor : buttonStyles.bgColor ?? context.theme.backgroundColor,
        child: InkWell(
          onTap: () {
            onTap(page);
          },
          child: page.toString()
              .text(style: active ? buttonStyles.activeTextStyle : buttonStyles.textStyle, textAlign: TextAlign.center)
              .center(),
        ),
      ).sized(
        h: height,
        w: MediaQuery.of(context).size.width,
      ),
    );
  }
}

class PageBtnStyles {
  final double? fontSize;
  final BorderRadius? borderRadius;
  final Color? bgColor;
  final Color? activeBgColor;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;

  PageBtnStyles({
    this.fontSize,
    this.bgColor,
    this.activeBgColor,
    this.borderRadius,
    this.textStyle,
    this.activeTextStyle,
  });

  PageBtnStyles copyWith({
    double? fontSize,
    BorderRadius? borderRadius,
    Color? bgColor,
    Color? activeBgColor,
    TextStyle? textStyle,
    TextStyle? activeTextStyle,
  }) =>
      PageBtnStyles(
        fontSize: fontSize ?? this.fontSize,
        bgColor: bgColor ?? this.bgColor,
        activeBgColor: activeBgColor ?? this.activeBgColor,
        borderRadius: borderRadius ?? this.borderRadius,
        textStyle: textStyle ?? this.textStyle,
        activeTextStyle: activeTextStyle ?? this.activeTextStyle,
      );
}

class SkipBtnStyle {
  final Icon? icon;
  final BorderRadius? borderRadius;
  final Color? color;

  SkipBtnStyle({this.icon, this.borderRadius, this.color});

  SkipBtnStyle copyWith({
    Icon? icon,
    BorderRadius? borderRadius,
    Color? color,
  }) =>
      SkipBtnStyle(
        icon: icon ?? this.icon,
        borderRadius: borderRadius ?? this.borderRadius,
        color: color ?? this.color,
      );

  SkipBtnStyle symmetricL2R() => copyWith(borderRadius: borderRadius?.symmetricL2R());
}

extension _BorderRadiusEx on BorderRadius {
  BorderRadius symmetricL2R() {
    return BorderRadius.only(topRight: topLeft, bottomRight: bottomLeft);
  }
}
