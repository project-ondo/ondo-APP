enum AlertState {
  newComment("누군가가 댓글을 남겼어요"),
  requestChat("누군가가 커피챗을 신청했어요"),
  reported("신고가 누적되어 커피챗 및 커뮤니티 활동이 제한되었습니다."),
  newReview("누군가로부터 리뷰가 왔어요"),
  overHeart("게시물의 좋아요 수가 50개를 넘었어요")
  ;

  final String title;

  const AlertState(this.title);
}
