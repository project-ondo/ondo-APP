import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  //Primary color(brown)
  static const Color primary = Color(0xff6D3300);
  static const Color primaryLight = Color(0xffDBCDBF);
  static const Color primaryDark = Color(0xff482506);
  static const Color background = Color(0xffFFFBF6);
  static Color lightButton = Color(
    0xff6F3700,
  ).withValues(alpha: 0.25); //조건 안 맞을 때 버튼 색

  //Action color
  static const Color yellow = Color(0xffFFCE3D);
  static const Color redLight = Color(0xffFFDEDE);
  static const Color red = Color(0xffFC624A);
  static const Color deepRed = Color(0xffED1E29);

  //Gray scale color
  static const Color black = Color(0xff000000);
  static const Color gray = Color(0xffB2B2B2); //0xffB2B2B2
  static const Color gray90 = Color(0xff222222); //0xff222222
  static const Color gray80 = Color(0xff444444); //0xff444444
  static const Color gray70 = Color(0xff888888); //0xff888888
  static const Color gray60 = Color(0xffBBBBBB); //0xffBBBBBB
  static const Color gray50 = Color(0xffC7C7C7); //0xffC7C7C7
  static const Color gray45 = Color(0xffC4C4C4); //0xffC4C4C4
  static const Color gray40 = Color(0xffDDDDDD); //0xffDDDDDD
  static const Color gray20 = Color(0xfff8f8f8); //0xffF8F8F8
  static const Color white = Color(0xffFFFFFF);
  static const Color shadowGray = Color(0x05781F07);
}
