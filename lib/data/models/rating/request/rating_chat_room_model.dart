import 'package:ondo/data/models/base/response/base_model.dart';

class RatingChatRequestModel extends BaseModel {
  final int star;
  final String comment;
  final List<String> tags;

  RatingChatRequestModel({
    required this.star,
    required this.comment,
    required this.tags,
  });

  @override
  Map<String, dynamic> toJson() => {
    "star": star,
    "comment": comment,
    "tags": tags.toString(),
  };
}
