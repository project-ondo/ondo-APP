class AppDateUtils {
  static String timeAgo(DateTime? dateTime) {
    if (dateTime == null) return "";

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

  /// 서버에서 받은 UTC 타임스탬프 문자열을 로컬 시간의 [DateTime]으로 변환한다.
  ///
  /// 서버가 timezone suffix 없이 `"2024-01-15T12:00:00"` 형태로 UTC 시간을
  /// 반환할 때, Dart의 [DateTime.parse]는 로컬 시간으로 취급해 KST(+09:00) 기기
  /// 에서 9시간 차이가 발생한다. 이 메서드는 suffix가 없으면 `Z`를 붙여
  /// UTC로 명시한 뒤 로컬 시간으로 변환한다.
  static DateTime parseUtc(String s) {
    final normalized = _withUtcSuffix(s);
    return DateTime.parse(normalized).toLocal();
  }

  /// [parseUtc]의 nullable 버전. 파싱 실패 시 `null` 반환.
  static DateTime? tryParseUtc(String? s) {
    if (s == null || s.isEmpty) return null;
    final normalized = _withUtcSuffix(s);
    return DateTime.tryParse(normalized)?.toLocal();
  }

  /// timezone 정보가 없는 문자열에 `Z` suffix를 붙인다.
  static String _withUtcSuffix(String s) {
    // 이미 Z, +, 또는 날짜 부분(10자) 이후에 - 가 있으면 timezone 있음
    final hasTimezone =
        s.endsWith('Z') ||
        s.contains('+') ||
        (s.length > 10 && s.substring(10).contains('-'));
    return hasTimezone ? s : '${s}Z';
  }
}
