class BaseListRequestModel {
  final int size;
  final int page;

  BaseListRequestModel({required this.size, required this.page});

  Map<String, dynamic> toJson() => {
    "size": size.toString(),
    "page": page.toString(),
  };
}
