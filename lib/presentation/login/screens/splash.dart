import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';


class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Image.asset(AppIcon.logo.path)],
        ),
      ),
    );
  }
}
