import 'package:flutter/material.dart';
import 'package:ondo/presentation/profile/widget/user_review_card.dart';

class CurrentReviewSession extends StatelessWidget {
  const CurrentReviewSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserReviewCard(
          userName: '김유찬',
          userReview: "상세하게 설명해주긴 하는데 좀 욕설이 섞여서 좀 저질스러움\n참고하세요",
          stars: 3,
        ),
        UserReviewCard(
          userName: '김유찬',
          userReview: "상세하게 설명해주긴 하는데 좀 욕설이 섞여서 좀 저질스러움\n참고하세요",
          stars: 3,
        ),
        UserReviewCard(
          userName: '김유찬',
          userReview: "상세하게 설명해주긴 하는데 좀 욕설이 섞여서 좀 저질스러움\n참고하세요",
          stars: 3,
        ),
      ],
    );
  }
}
