import 'package:ondo/data/models/base/response/base_model.dart';

class RatingChatRequestModel extends BaseModel {
  final int stars;
  final String comment;
  final List<String> tags;

  RatingChatRequestModel({
    required this.stars,
    required this.comment,
    required this.tags,
  });

  @override
  Map<String, dynamic> toJson() => {
    "stars": stars,
    "comment": comment,
    "tags": tags,
  };
}
