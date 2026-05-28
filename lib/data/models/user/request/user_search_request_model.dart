class UserSearchRequestModel {
  final String? keyword;
  final String? major;
  final List<String>? interests;
  final String? sort;
  final int? page;
  final int? size;

  UserSearchRequestModel({
    required this.keyword,
    required this.major,
    required this.interests,
    required this.sort,
    required this.page,
    required this.size,
  });

  String toQueryString() {
    final params = <String>[];
    if (keyword != null) params.add('keyword=${Uri.encodeQueryComponent(keyword!)}');
    if (major != null) params.add('major=${Uri.encodeQueryComponent(major!)}');
    if (interests != null) {
      for (final interest in interests!) {
        params.add('interests=${Uri.encodeQueryComponent(interest)}');
      }
    }
    if (sort != null) params.add('sort=${Uri.encodeQueryComponent(sort!)}');
    if (page != null) params.add('page=$page');
    if (size != null) params.add('size=$size');
    return "?${params.join('&')}";
  }
}
