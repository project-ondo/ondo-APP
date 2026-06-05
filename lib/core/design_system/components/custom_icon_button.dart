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

class CustomIconButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            final newIsSelected =
            !initialIsSelected;

            final newTotal =
            newIsSelected
                ? total + 1
                : total - 1;

            action?.call(
              newIsSelected,
              newTotal,
            );
          },
          child: Image.asset(
            imagePath,
            color: initialIsSelected
                ? activeColor
                : AppColors.gray50,
            height: iconSize,
            width: iconSize,
          ),
        ),
        AppGap.h4,
        Text(
          "$total",
          style: TextStyle(
            fontSize:
            totalStyle.fontSize,
            fontWeight:
            totalStyle.fontWeight,
            color:
            AppColors.gray60,
          ),
        ),
      ],
    );
  }
}