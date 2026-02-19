import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../app_colors.dart';
import '../app_icon.dart';
import '../app_layout.dart';

class CustomPopupMenuButton extends StatelessWidget {
  const CustomPopupMenuButton({super.key, required this.itemBuilder});
  final PopupMenuItemBuilder<String> itemBuilder;

  @override
  Widget build(BuildContext context) {

    return PopupMenuButton(
      offset: const Offset(-6, 13),
      color: AppColors.white,
      borderRadius: AppRadius.baseRadius,
      constraints: BoxConstraints(minWidth: 0),
      itemBuilder: itemBuilder,
      child: SvgPicture.asset(AppIcon.menu.path)
    );
  }
}
