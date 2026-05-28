import 'package:get/get.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/domain/entities/user/user_entity.dart';

mixin BaseHomeController {
  final RxList<PostEntity> viewPostList = <PostEntity>[].obs;
  final RxList<UserEntity> viewUserList = <UserEntity>[].obs;
}
