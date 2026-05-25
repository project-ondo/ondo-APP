import 'package:get/get.dart';
import 'package:ondo/domain/usecases/comment/create_comment_usecase.dart';
import 'package:ondo/domain/usecases/comment/delete_comment_usecase.dart';
import 'package:ondo/domain/usecases/comment/get_comments_usecase.dart';

import '../../../data/datasource/comment/comment_remote_datasource.dart';
import '../../../data/datasource/post/post_local_datasource.dart';
import '../../../data/datasource/post/post_remote_datasource.dart';
import '../../../data/network/clients/auth_client.dart';
import '../../../data/repositories/comment/comment_repository_impl.dart';
import '../../../data/repositories/post/post_repository_impl.dart';

import '../../../domain/usecases/post/bookmark_post_usecase.dart';
import '../../../domain/usecases/post/create_post_usecase.dart';
import '../../../domain/usecases/post/delete_post_usecase.dart';
import '../../../domain/usecases/post/get_post_detail_usecase.dart';
import '../../../domain/usecases/post/like_post_usecase.dart';
import '../../../domain/usecases/post/unbookmark_post_usecase.dart';
import '../../../domain/usecases/post/unlike_post_usecase.dart';
import '../../../domain/usecases/post/update_post_usecase.dart';

import '../../../presentation/post/controllers/post_view_controller.dart';

class PostBinding extends Bindings {
  final int postId;
  final bool isFavorite;

  PostBinding(
      this.postId, [
        this.isFavorite = false,
      ]);

  @override
  void dependencies() {
    // Post DataSource
    Get.lazyPut<PostRemoteDatasource>(
          () => PostRemoteDatasourceImpl(
        Get.find<AuthClient>(),
      ),
    );

    Get.lazyPut<PostLocalDatasource>(
          () => PostLocalDatasource(),
    );

    // Post Repository
    Get.lazyPut<PostRepositoryImpl>(
          () => PostRepositoryImpl(
        Get.find<PostRemoteDatasource>(),
        Get.find<PostLocalDatasource>(),
      ),
    );

    // Post UseCases
    Get.lazyPut<GetPostDetailUseCase>(
          () => GetPostDetailUseCase(
        Get.find<PostRepositoryImpl>(),
      ),
    );

    Get.lazyPut<CreatePostUseCase>(
          () => CreatePostUseCase(
        Get.find<PostRepositoryImpl>(),
      ),
    );

    Get.lazyPut<UpdatePostUseCase>(
          () => UpdatePostUseCase(
        Get.find<PostRepositoryImpl>(),
      ),
    );

    Get.lazyPut<DeletePostUseCase>(
          () => DeletePostUseCase(
        Get.find<PostRepositoryImpl>(),
      ),
    );

    Get.lazyPut<LikePostUseCase>(
          () => LikePostUseCase(
        Get.find<PostRepositoryImpl>(),
      ),
    );

    Get.lazyPut<UnlikePostUseCase>(
          () => UnlikePostUseCase(
        Get.find<PostRepositoryImpl>(),
      ),
    );

    // 추가된 북마크 UseCase
    Get.lazyPut<BookmarkPostUseCase>(
          () => BookmarkPostUseCase(
        Get.find<PostRepositoryImpl>(),
      ),
    );

    Get.lazyPut<UnbookmarkPostUseCase>(
          () => UnbookmarkPostUseCase(
        Get.find<PostRepositoryImpl>(),
      ),
    );

    // Comment DataSource
    Get.lazyPut<CommentRemoteDataSource>(
          () => CommentRemoteDataSourceImpl(
        Get.find<AuthClient>(),
      ),
    );

    // Comment Repository
    Get.lazyPut<CommentRepositoryImpl>(
          () => CommentRepositoryImpl(
        remoteDataSource:
        Get.find<CommentRemoteDataSource>(),
      ),
    );

    // Comment UseCases
    Get.lazyPut<GetCommentsUseCase>(
          () => GetCommentsUseCase(
        Get.find<CommentRepositoryImpl>(),
      ),
    );

    Get.lazyPut<CreateCommentUseCase>(
          () => CreateCommentUseCase(
        Get.find<CommentRepositoryImpl>(),
      ),
    );

    Get.lazyPut<DeleteCommentUseCase>(
          () => DeleteCommentUseCase(
        Get.find<CommentRepositoryImpl>(),
      ),
    );

    // Controller
    Get.put<PostViewController>(
      PostViewController(
        postId: postId,
        initialIsFavorite: isFavorite,
        useCase: Get.find<GetPostDetailUseCase>(),
        updateUseCase:
        Get.find<UpdatePostUseCase>(),
        deleteUseCase:
        Get.find<DeletePostUseCase>(),
        likeUseCase:
        Get.find<LikePostUseCase>(),
        unlikeUseCase:
        Get.find<UnlikePostUseCase>(),

        // 추가
        bookmarkUseCase:
        Get.find<BookmarkPostUseCase>(),
        unbookmarkUseCase:
        Get.find<UnbookmarkPostUseCase>(),

        getCommentsUseCase:
        Get.find<GetCommentsUseCase>(),
        createCommentUseCase:
        Get.find<CreateCommentUseCase>(),
        deleteCommentUseCase:
        Get.find<DeleteCommentUseCase>(),
      ),
    );
  }
}