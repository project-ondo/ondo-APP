enum NotificationType {
  chatMessage('CHAT_MESSAGE'),
  matchCreated('MATCH_CREATED'),
  postComment('POST_COMMENT'),
  rateRequest('RATE_REQUEST'),
  postLike('POST_LIKE'),
  chatMemberLeft('CHAT_MEMBER_LEFT'),
  reportReceived('REPORT_RECEIVED'),
  reportResolved('REPORT_RESOLVED'),
  reportContentDeleted('REPORT_CONTENT_DELETED'),
  userSuspended('USER_SUSPENDED'),
  unknown('UNKNOWN')
  ;

  final String value;

  const NotificationType(this.value);
}
