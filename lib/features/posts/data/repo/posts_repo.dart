import 'package:dartz/dartz.dart';
import 'package:leaptech_plus/core/errors/failure.dart';
import 'package:leaptech_plus/features/posts/data/models/post_with_relation_model.dart';

abstract class PostsRepo {
  Future<Either<Failure, void>> addPost({
    required String userId,
    required String? content,
    List<String>? imageUrls,
  });
  Future<Either<Failure, void>> deletePost({required String postId});
  Future<Either<Failure, List<PostWithRelations>>> getAllPosts();
  Future<Either<Failure, void>> toggleLike({
    required String postId,
    required String userId,
  });
  Future<Either<Failure, void>> addComment({
    required String postId,
    required String userId,
    required String commentText,
  });
}
