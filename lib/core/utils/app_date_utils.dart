class AppDateUtils {
  static final RegExp _nanoSecondsRegex = RegExp(r'(\.\d{6})\d+(Z|[+-].*)$');
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
  ///
  /// 시간 파트(`T` 또는 공백)가 없는 날짜 전용 문자열(예: `"2024-01-15"`)은
  /// `DateTime.parse()`가 시간대 접미사를 지원하지 않으므로 그대로 반환한다.
  ///
  /// Dart의 [DateTime.parse]는 소수점 이하 최대 6자리(마이크로초)만 지원한다.
  /// 서버가 나노초(9자리) 등 더 긴 소수점을 반환하면 파싱이 실패하므로
  /// 소수점 7자리 이상은 잘라낸다.
  static String _withUtcSuffix(String s) {
    // 시간 파트가 없으면 Z 붙여도 FormatException 발생 → 그대로 반환
    final hasTimePart = s.contains('T') || s.contains(' ');
    if (!hasTimePart) return s;

    // 이미 Z, +, 또는 날짜 부분(10자) 이후에 - 가 있으면 timezone 있음
    final hasTimezone =
        s.endsWith('Z') ||
        s.contains('+') ||
        (s.length > 10 && s.substring(10).contains('-'));
    final withZ = hasTimezone ? s : '${s}Z';

    // 소수점 이하 7자리 이상 잘라내기 (나노초 → 마이크로초)
    return withZ.replaceFirstMapped(
      _nanoSecondsRegex,
      (m) => '${m.group(1)}${m.group(2)}',
    );
  }
}
