abstract class BaseListRequestModel {
  final int start;
  final int size;

  BaseListRequestModel({required this.start, required this.size});

  String toQueryParameter();
}

class ListRequestModelBasePage extends BaseListRequestModel {
  final int page;

  ListRequestModelBasePage({required super.size, required this.page})
    : super(start: page);

  @override
  String toQueryParameter() => "?size=$size&page=$page";
}

class ListRequestModelBaseCursor extends BaseListRequestModel {
  final int cursor;

  ListRequestModelBaseCursor({required super.size, required this.cursor})
    : super(start: cursor);

  @override
  String toQueryParameter() => "?size=$size&cursor=$cursor";
}
