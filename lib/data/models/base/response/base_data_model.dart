import 'package:ondo/data/models/base/response/base_model.dart';

abstract class BaseDataModel<T extends BaseModel> {
  final List<T> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool? last;

  BaseDataModel({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  Map<String, dynamic> toJson() => {
    "content": content
        .map(
          (e) => e.toJson(),
        )
        .toList(),
    "page": page,
    "size": size,
    "totalElements": totalElements,
    "totalPages": totalPages,
    "last": last,
  };
}
