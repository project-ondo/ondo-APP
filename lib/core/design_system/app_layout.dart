import 'dart:core';
import 'package:flutter/material.dart';

class AppSpacing {
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s9 = 9;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s36 = 36;
}

class AppGap {
  static const SizedBox h4 = SizedBox(width: AppSpacing.s4);
  static const SizedBox h6 = SizedBox(width: AppSpacing.s6);
  static const SizedBox h8 = SizedBox(width: AppSpacing.s8);
  static const SizedBox h10 = SizedBox(width: AppSpacing.s10);
  static const SizedBox h12 = SizedBox(width: AppSpacing.s12);
  static const SizedBox h16 = SizedBox(width: AppSpacing.s16);
  static const SizedBox h24 = SizedBox(width: AppSpacing.s24);
  static const SizedBox h36 = SizedBox(width: AppSpacing.s36);

  static const SizedBox v4 = SizedBox(height: AppSpacing.s4);
  static const SizedBox v6 = SizedBox(height: AppSpacing.s6);
  static const SizedBox v8 = SizedBox(height: AppSpacing.s8);
  static const SizedBox v10 = SizedBox(height: AppSpacing.s10);
  static const SizedBox v12 = SizedBox(height: AppSpacing.s12);
  static const SizedBox v16 = SizedBox(height: AppSpacing.s16);
  static const SizedBox v24 = SizedBox(height: AppSpacing.s24);
  static const SizedBox v36 = SizedBox(height: AppSpacing.s36);
}

class AppPadding {
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(
    horizontal: AppSpacing.s16,
  );

  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: AppSpacing.s16,
  );

  static const EdgeInsets textField = EdgeInsets.symmetric(
    horizontal: AppSpacing.s16,
    vertical: AppSpacing.s12,
  );

  static const EdgeInsets card = EdgeInsets.all(AppSpacing.s12);

  static const EdgeInsets userCard = EdgeInsets.all(AppSpacing.s10);

  static const EdgeInsets chip = EdgeInsets.symmetric(
    horizontal: AppSpacing.s12,
    vertical: AppSpacing.s8,
  );

  static const EdgeInsets basePopup = EdgeInsets.symmetric(
    horizontal: AppSpacing.s16,
    vertical: AppSpacing.s24,
  );

  static const EdgeInsets actionPopup = EdgeInsets.symmetric(
    horizontal: AppSpacing.s12,
    vertical: AppSpacing.s24,
  );

  static const EdgeInsets topBar = EdgeInsets.symmetric(
    horizontal: AppSpacing.s16,
    vertical: AppSpacing.s16,
  );

  static const EdgeInsets popUp = EdgeInsets.only(
    bottom: AppSpacing.s24,
    left: AppSpacing.s16,
    right: AppSpacing.s16,
  );

}

class AppRadius {
  static const BorderRadius baseRadius = BorderRadius.all(
    Radius.circular(AppSpacing.s8),
  );

  static const BorderRadius userCardRadius = BorderRadius.all(
    Radius.circular(AppSpacing.s9),
  );

  static const BorderRadius popupRadius = BorderRadius.all(
    Radius.circular(AppSpacing.s12),
  );

  static const BorderRadius circleRadius = BorderRadius.all(
    Radius.circular(99),
  );

  static const BorderRadius alertRadius = BorderRadius.all(
    Radius.circular(AppSpacing.s6),
  );
}
