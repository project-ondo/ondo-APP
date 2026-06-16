enum ReportType {
  post('POST'),
  comment('COMMENT'),
  chatRoom('CHAT_ROOM'),
  user('USER')
  ;

  final String value;

  const ReportType(this.value);
}

enum ReportReason {
  swear("욕설이 많아요"),
  disrespect("상대를 존중하지 않아요"),
  offensive("불쾌감을 느끼는 발언을 해요"),
  aggressive("공격적인 언어를 사용해요"),
  discrimination("신분, 장애, 인종에 대해 차별 발언을 일삼아요"),
  badName("부적절한 이름을 사용해요"),
  etc("기타")
  ;

  final String label;

  const ReportReason(this.label);
}
