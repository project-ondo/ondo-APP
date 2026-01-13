import 'package:flutter/cupertino.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_layout.dart';

class TermsAgreementCard {
  static Container termsAgreementCard = Container(
    padding: EdgeInsets.all(AppSpacing.s16),
    decoration: BoxDecoration(
      color: AppColors.gray20,
      borderRadius: AppRadius.baseRadius,
    ),
    child: Text(
      '[개인정보 수집 및 이용 동의] '
      '\n\n온도(ONDO)는 다음과 같이 개인정보를 수집 및 이용하고 있습니다. '
      '\n  - 수집 및 이용 목적: 회원 가입, 서비스 제공, 이용자 식별, 부정이용 방지, 중복가입 방지 '
      '\n  - 항목: 아이디, 닉네임, 비밀번호, 이메일주소 '
      '\n  - 보유 및 이용기간: 회원탈퇴일로부터 30일 (법령에 특별한 규정이 있을 경우 관련 법령에 따라, 부정이용기 록은 회원탈퇴일로부터 최대 5년)'
      '\n동의를 거부할 권리가 있으나, 동의를 거부할 경우 회원가입이 불가능 합니다.'
      '\n\n※ 그 외의 사항 및 자동 수집 정보와 관련된 사항은 개인정보처리방침을따릅니다.',
      style: TextStyle(
        color: AppColors.gray90,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
