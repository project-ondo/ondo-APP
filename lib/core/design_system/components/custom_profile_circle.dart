import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';

class CustomProfileCircle extends StatelessWidget {
  const CustomProfileCircle({super.key, required this.radius, this.imageUrl})
    : hasImage = imageUrl != null;

  final double radius;
  final String? imageUrl;
  final bool hasImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        borderRadius: AppRadius.circleRadius,
        image: hasImage
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child: !hasImage
          ? SvgPicture.asset(
              AppIcon.defaultProfile.path,
              fit: BoxFit.cover,
            )
          : null,
    );
  }
}
