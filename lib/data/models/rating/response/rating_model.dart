import 'package:ondo/data/models/base/response/base_model.dart';

class RatingDataModel {
  final List<RatingModel> items;
  final int? nextCursor;
  final bool hasNext;

  RatingDataModel({
    required this.items,
    required this.nextCursor,
    required this.hasNext,
  });

  factory RatingDataModel.fromJson(Map json) => RatingDataModel(
    items: (json["items"] as List)
        .map(
          (e) => RatingModel.fromJson(e),
        )
        .toList(),
    nextCursor: json["nextCursor"],
    hasNext: json["hasNext"],
  );
}

class RatingModel extends BaseModel {
  final int id;
  final int stars;
  final String comment;
  final List<String> tags;
  final String createdAt;

  RatingModel({
    required this.id,
    required this.stars,
    required this.comment,
    required this.tags,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map json) => RatingModel(
    id: json["id"],
    stars: json["stars"],
    comment: json["comment"],
    tags: (json["tags"] as List)
        .map(
          (e) => e.toString(),
        )
        .toList(),
    createdAt: json["createdAt"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "stars": stars,
    "comment": comment,
    "tags": tags,
    "createdAt": createdAt,
  };
}
