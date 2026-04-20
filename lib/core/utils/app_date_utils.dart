class AppDateUtils {
  static String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays < 365) {
      return '${diff.inDays}일 전';
    } else {
      return '${diff.inDays ~/ 365}년 전';
    }
}
}
