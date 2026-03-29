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
    total = widget.total;
    isSelect = widget.initialIsSelected;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isSelect = !isSelect;
              isSelect ? total += 1 : total -= 1;
            });
            widget.action?.call(isSelect, total);
          },
          child: Image.asset(
            widget.imagePath,
            color: isSelect ? widget.activeColor : AppColors.gray50,
            height: widget.iconSize,
            width: widget.iconSize,
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
    );
  }
}
