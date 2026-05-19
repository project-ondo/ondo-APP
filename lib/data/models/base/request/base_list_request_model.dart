abstract class BaseListRequestModel {
  final int start;
  final int size;

  BaseListRequestModel({required this.start, required this.size});

  String toQueryParameter();
}

class ListRequestModel extends BaseListRequestModel {
  final int page;

  ListRequestModel({required super.size, required this.page})
    : super(start: page);

  @override
  String toQueryParameter() => "?size=$size&page=$page";
}
