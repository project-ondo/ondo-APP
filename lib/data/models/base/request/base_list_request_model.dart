class BaseListRequestModel {
  final int size;
  final int page;

  BaseListRequestModel({required this.size, required this.page});

  String toQueryParameter() => "?size=$size&page=$page";
}
