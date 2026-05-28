class PostSearchRequestModel {
  final String keyword;
  late final List<String>? tags;
  final String? sort;
  final bool? latest;
  final int? page;
  final int? size;

  PostSearchRequestModel({
    required this.keyword,
    required this.tags,
    required this.sort,
    required this.latest,
    required this.page,
    required this.size,
  });

  String toQueryParameter() {
    final params = <String>[];

    params.add("keyword=${Uri.encodeQueryComponent(keyword)}");
    if (tags != null) {
      for (String tag in tags!) {
        params.add("tags=${Uri.encodeQueryComponent(tag)}");
      }
    }
    if (sort != null) params.add("sort=${Uri.encodeQueryComponent(sort!)}");
    if (latest != null)
      params.add("latest=${Uri.encodeQueryComponent(latest!.toString())}");
    if (page != null)
      params.add("page=${Uri.encodeQueryComponent(page!.toString())}");
    if (size != null)
      params.add("size=${Uri.encodeQueryComponent(size!.toString())}");
    return '?${params.join('&')}';
  }
}
