import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';

class CustomProfileCircle extends StatelessWidget {
  const CustomProfileCircle({super.key, required this.radius, this.imageUrl});

  final double radius;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: AppRadius.circleRadius,
      ),
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _defaultImage(),
            )
          : _defaultImage(),
    );
  }

  Widget _defaultImage() => SvgPicture.asset(
    AppIcon.defaultProfile.path,
    fit: BoxFit.cover,
  );
}
