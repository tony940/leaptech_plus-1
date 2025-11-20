import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:leaptech_plus/core/errors/failure.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/features/posts/data/models/post_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_comment_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_user_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_with_relation_model.dart';
import 'package:leaptech_plus/features/posts/data/repo/posts_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostsRepoImpl implements PostsRepo {
  final SupabaseService _supabaseService;

  PostsRepoImpl({required SupabaseService supabaseService})
      : _supabaseService = supabaseService;

  @override
  Future<Either<Failure, List<PostWithRelations>>> getAllPosts() async {
    try {
      final rawData = await _supabaseService.getAllPostsWithRelations();

      final posts = rawData.map((postMap) {
        final post = PostModel.fromMap(postMap);

        // Comments
        final commentsData = postMap['post_comments'] as List<dynamic>? ?? [];
        final comments = commentsData
            .map((c) => PostCommentModel.fromMap(c as Map<String, dynamic>))
            .toList();

        // Likes
        final likesData = postMap['post_likes'] as List<dynamic>? ?? [];
        final likes = likesData
            .map(
                (l) => PostUserModel.fromMap(l['user'] as Map<String, dynamic>))
            .toList();

        // Images
        final imagesData = postMap['post_images'] as List<dynamic>? ?? [];
        final images =
            imagesData.map((img) => img['image_url'] as String).toList();

        return PostWithRelations(
          post: post,
          comments: comments,
          likes: likes,
          images: images,
        );
      }).toList();

      return Right(posts);
    } on PostgrestException catch (e) {
      return Left(SupbaseFailure.postgrestErrorHandler(e));
    } on SocketException catch (e) {
      return Left(Failure(
          errorMessage:
              "No internet connection detected. Please check your network and try again."));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleLike({
    required String postId,
    required String userId,
  }) async {
    try {
      await _supabaseService.toggleLike(
        postId: postId,
        userId: userId,
      );
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(SupbaseFailure.postgrestErrorHandler(e));
    } on SocketException catch (e) {
      return Left(Failure(errorMessage: 'No internet connection.'));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addPost({required PostModel postModel}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deletePost({required int postId}) {
    throw UnimplementedError();
  }
}
