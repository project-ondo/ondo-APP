import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';

typedef FavoriteAction = void Function(bool isFavorite, int total);
typedef BookmarkAction = void Function(bool isBookmark, int total);

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    super.key,
    required this.imagePath,
    required this.total,
    required this.activeColor,
    this.action,
    this.initialIsSelected = false,
    required this.iconSize,
    required this.totalStyle,
  });

  final String imagePath;
  final double iconSize;
  final TextStyle totalStyle;
  final int total;
  final bool initialIsSelected;
  final Color activeColor;
  final void Function(bool isSelect, int total)? action;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  late int total;
  late bool isSelect;

  @override
  void initState() {
    super.initState();
    total = widget.total;
    isSelect = widget.initialIsSelected;
  }

  @override
  void didUpdateWidget(CustomIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.total != widget.total) {
      total = widget.total;
    }
    if (oldWidget.initialIsSelected != widget.initialIsSelected) {
      isSelect = widget.initialIsSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final touchSize = widget.iconSize < 32 ? 32.0 : widget.iconSize;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: touchSize,
            child: Center(
              child: Image.asset(
                widget.imagePath,
                color: isSelect ? widget.activeColor : AppColors.gray50,
                height: widget.iconSize,
                width: widget.iconSize,
              ),
            ),
          ),
          AppGap.h4,
          Text(
            "$total",
            style: TextStyle(
              fontSize: widget.totalStyle.fontSize,
              fontWeight: widget.totalStyle.fontWeight,
              color: AppColors.gray60,
            ),
          ),
        ],
      ),
    );
  }

  void _toggle() {
    setState(() {
      isSelect = !isSelect;
      total = _nextTotal(isSelect);
    });
    widget.action?.call(isSelect, total);
  }

  int _nextTotal(bool willSelect) {
    final next = total + (willSelect ? 1 : -1);
    return next < 0 ? 0 : next;
  }
}
