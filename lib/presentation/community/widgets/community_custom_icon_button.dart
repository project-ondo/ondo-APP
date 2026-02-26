import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class CommunityCustomIconButton extends StatefulWidget {
  const CommunityCustomIconButton({
    super.key,
    required this.imagePath,
    required this.total,
    required this.activeColor,
    required this.action,
    this.initialIsSelected = false,
  });

  final String imagePath;
  final int total;
  final bool initialIsSelected;
  final Color activeColor;
  final void Function(bool isSelect, int total) action;

  @override
  State<CommunityCustomIconButton> createState() =>
      _CommunityCustomIconButtonState();
}

class _CommunityCustomIconButtonState extends State<CommunityCustomIconButton> {
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
            widget.action.call(isSelect, total);
          },
          child: Image.asset(
            widget.imagePath,
            color: isSelect ? widget.activeColor : AppColors.gray50,
            height: AppSpacing.s32,
            width: AppSpacing.s32,
          ),
        ),
        AppGap.h4,
        Text(
          "$total",
          style: AppTextStyles.textMedium(textColor: AppColors.gray50),
        ),
      ],
    );
  }
}
