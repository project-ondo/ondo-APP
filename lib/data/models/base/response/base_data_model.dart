abstract class BaseDataModel<T> {
  final List<T> content;
  final int page;
  final int size;
  final int? totalElement;
  final int totalPages;
  final bool? last;

  BaseDataModel({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElement,
    required this.totalPages,
    required this.last,
  });

  Map toJson();
}

/*
 "data": {
        "content": {},
        "page": 0,
        "size": 0,
        "totalElement": 0,
        "totalPages": 0,
        "last": true
    }
* */
