import 'package:ondo/data/models/rating/response/rating_model.dart';

class RatingEntity {
  final int id;
  final int stars;
  final String comment;
  final List<String> tags;
  final DateTime createdAt;

  RatingEntity({
    required this.id,
    required this.stars,
    required this.comment,
    required this.tags,
    required this.createdAt,
  });

  factory RatingEntity.fromRatingModel(RatingModel model) => RatingEntity(
    id: model.id,
    stars: model.stars,
    comment: model.comment,
    tags: model.tags,
    createdAt: DateTime.tryParse(model.createdAt) ?? DateTime.now(),
  );
}
