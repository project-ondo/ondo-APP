import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';

typedef FavoriteAction = void Function(
    bool isFavorite,
    int total,
    );

typedef BookmarkAction = void Function(
    bool isBookmark,
    int total,
    );

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
  final void Function(
      bool isSelect,
      int total,
      )? action;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  late bool _isSelected;
  late int _total;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initialIsSelected;
    _total = widget.total;
  }

  @override
  void didUpdateWidget(CustomIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 외부(컨트롤러)에서 갱신된 값이 들어오면 내부 상태에 반영한다.
    if (oldWidget.initialIsSelected != widget.initialIsSelected) {
      _isSelected = widget.initialIsSelected;
    }
    if (oldWidget.total != widget.total) {
      _total = widget.total;
    }
  }

  void _onTap() {
    setState(() {
      _isSelected = !_isSelected;
      _total += _isSelected ? 1 : -1;
    });

    widget.action?.call(_isSelected, _total);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _onTap,
          child: Image.asset(
            widget.imagePath,
            color: _isSelected ? widget.activeColor : AppColors.gray50,
            height: widget.iconSize,
            width: widget.iconSize,
          ),
        ),
        AppGap.h4,
        Text(
          "$_total",
          style: widget.totalStyle.copyWith(color: AppColors.gray60),
        ),
      ],
    );
  }
}