class BaseSearchRequestModel {
  final String? keyword;
  final String? major;
  final List<String>? interests;
  final String? sort;
  final int? page;
  final int? size;

  BaseSearchRequestModel({
    required this.keyword,
    required this.major,
    required this.interests,
    required this.sort,
    required this.page,
    required this.size,
  });

  Map<String, List<String>> toQueryParametersAll() {
    final map = <String, List<String>>{};
    if (keyword != null) map['keyword'] = [keyword!];
    if (major != null) map['major'] = [major!];
    if (interests != null && interests!.isNotEmpty) map['interests'] = interests!;
    if (sort != null) map['sort'] = [sort!];
    if (page != null) map['page'] = [page.toString()];
    if (size != null) map['size'] = [size.toString()];
    return map;
  }
}
