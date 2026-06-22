import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_text_styles.dart';

class AppEmptyState extends StatelessWidget {
  final String message;
  final AppIcon? icon;

  const AppEmptyState({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            _buildIcon(icon!),
            const SizedBox(height: 12),
          ],
          Text(
            message,
            style: AppTextStyles.textMedium(textColor: AppColors.gray60),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(AppIcon appIcon) {
    const size = 48.0;
    final path = appIcon.path;
    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: size,
        height: size,
        colorFilter: const ColorFilter.mode(AppColors.gray60, BlendMode.srcIn),
      );
    }
    return Image.asset(
      path,
      width: size,
      height: size,
      color: AppColors.gray60,
    );
  }
}
