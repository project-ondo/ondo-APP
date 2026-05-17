class PostUpdateRequestModel {
  final String title;
  final String content;
  final List<String> tags;

  const PostUpdateRequestModel({
    required this.title,
    required this.content,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'tags': tags,
  };
}