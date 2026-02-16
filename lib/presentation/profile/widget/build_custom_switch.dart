import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_layout.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class BuildCustomSwitch extends StatelessWidget {
  const BuildCustomSwitch({
    super.key,
    required this.name,
    required this.value,
    this.onChanged,
  });

  final String name;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: AppTextStyles.textMedium(
            textColor: AppColors.gray90,
          ),
        ),
        SizedBox(
          height: AppSpacing.s28,
          width: AppSpacing.s42,
          child: FittedBox(
            fit: BoxFit.fill,
            child: CupertinoSwitch(
              focusColor: AppColors.primary,
              activeTrackColor: AppColors.primary,
              inactiveThumbColor: AppColors.gray40,
              inactiveTrackColor: AppColors.gray20,
              value: value,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
