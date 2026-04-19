import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/design_system/app_layout.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            alignment: Alignment.center,
            width: AppSpacing.s80,
            height: AppSpacing.s80,
            decoration: BoxDecoration(
              borderRadius: AppRadius.circleRadius,
              border: Border.all(width: 2, color: Colors.brown),
            ),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                width: AppSpacing.s80,
                height: AppSpacing.s80,
                errorWidget: (_, _, _) => _defaultImage(),
              )
                  : _defaultImage(),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 4,
            child: SvgPicture.asset(
              AppIcon.star1.path,
              height: 35,
              width: 32,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultImage() => SvgPicture.asset(
    AppIcon.defaultProfile.path,
    fit: BoxFit.cover,
    width: AppSpacing.s80,
    height: AppSpacing.s80,
  );
}