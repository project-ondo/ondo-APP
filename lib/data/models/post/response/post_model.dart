import 'package:ondo/data/models/base/response/base_model.dart';

import '../../base/response/base_data_model.dart';

class PostDataModel extends BaseDataModel<PostModel> {
  PostDataModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalElements,
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
    totalElements: json["totalElements"],
    totalPages: json["totalPages"],
    last: json["last"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "content": content.map(
      (e) => e.toJson(),
    ),
    "page": page,
    "size": size,
    "totalElements": totalElements,
    "totalPages": totalPages,
    "last": last,
  };
}

//TODO : bookmarkCount, createAt 서버 api로부터 받기
class PostModel extends BaseModel {
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

  @override
  Map<String, dynamic> toJson() => {
    "postId": postId,
    "title": title,
    "authorName": authorName,
    "tags": tags,
    "viewCount": viewCount,
    "likeCount": likeCount,
    "commentCount": commentCount,
  };
}
