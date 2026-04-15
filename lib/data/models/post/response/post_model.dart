import '../../base/response/base_data_model.dart';

//posts/recommend
class PostDataModel extends BaseDataModel<PostModel> {
  PostDataModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalElement,
    required super.totalPages,
    required super.last,
  });

  factory PostDataModel.fromJson(Map json) => PostDataModel(
    content:
        (json["content"] as List?)
            ?.map(
              (e) => PostModel.fromJson(e),
            )
            .toList() ??
        [],
    page: json["page"],
    size: json["size"],
    totalElement: json["totalElements"],
    totalPages: json["totalPages"],
    last: json["last"],
  );

  @override
  Map toJson() => {
    "content": content.map(
      (e) => e.toJson(),
    ),
    "page": page,
    "size": size,
    "totalElements": totalElement,
    "totalPages": totalPages,
    "last": last,
  };
}

class PostModel {
  final int postId;
  final String title;
  final String authorName;
  final List<String> tags;
  final int viewCount;
  final int likeCount;
  final int commentCount;

  PostModel({
    required this.postId,
    required this.title,
    required this.authorName,
    required this.tags,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
  });

  factory PostModel.fromJson(Map json) => PostModel(
    postId: json["postId"],
    title: json["title"],
    authorName: json["authorName"],
    tags: (json["tags"] as List).cast<String>(),
    viewCount: json["viewCount"],
    likeCount: json["likeCount"],
    commentCount: json["commentCount"],
  );

  Map<dynamic, dynamic> toJson() => {
    "postId": postId,
    "title": title,
    "authorName": authorName,
    "tags": tags,
    "viewCount": viewCount,
    "likeCount": likeCount,
    "commentCount": commentCount,
  };
}

/*
{
    "success": true,
    "message": 0,
    "data": {
        "content": {
            "postId": "string",
            "title": "string",
            "authorName": "string",
            "tags": [
                "string"
            ],
            "viewCount": 0,
            "likeCount": 0,
            "commentCount": 0
        },
        "page": 0,
        "size": 0,
        "totalElement": 0,
        "totalPages": 0,
        "last": true
    },
}
*/
