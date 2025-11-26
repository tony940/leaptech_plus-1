import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:leaptech_plus/features/posts/data/models/post_user_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_with_relation_model.dart';
import 'package:leaptech_plus/features/posts/data/repo/posts_repo_impl.dart';
import 'package:meta/meta.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostsRepoImpl _postsRepo;

  PostsCubit(this._postsRepo) : super(PostsInitial());

  List<PostWithRelations> allPosts = [];

  // Load all posts
  Future<void> getAllPosts() async {
    emit(PostsGetAllPostsLoading());
    final response = await _postsRepo.getAllPosts();
    response
        .fold((failure) => emit(PostsGetAllPostsFailure(failure.errorMessage)),
            (posts) {
      allPosts = posts;
      if (!isClosed) emit(PostsGetAllPostsSuccess(posts));
    });
  }

  // Toggle like — no optimistic update
  Future<void> toggleLike({
    required String postId,
    required PostUserModel currentUser,
  }) async {
    // 1️⃣ Find the post locally
    final postIndex = allPosts.indexWhere((p) => p.post.id == postId);
    if (postIndex == -1) return;

    final post = allPosts[postIndex];
    final likes = post.likes;
    // 2️⃣ Check if user already liked
    final alreadyLiked = likes.any((user) => user.id == currentUser.id);

    // 3️⃣ Update likes list
    if (alreadyLiked) {
      likes.removeWhere((user) => user.id == currentUser.id); // unlike
    } else {
      likes.add(currentUser); // like
    }

    // 4️⃣ Optimistic update
    allPosts[postIndex] = post.copyWith(likes: likes);
    emit(PostsGetAllPostsSuccess(allPosts));

    // 5️⃣ Server request
    final response = await _postsRepo.toggleLike(
      postId: postId,
      userId: currentUser.id,
    );

    // 6️⃣ Handle failure (revert)
    response.fold(
      (failure) {
        allPosts[postIndex] = post; // revert
        emit(PostsGetAllPostsFailure(failure.errorMessage));
        emit(PostsGetAllPostsSuccess(allPosts));
      },
      (_) {
        // optionally refresh from server
      },
    );
  }

  //add comment
  Future<void> addComment({
    required String postId,
    required String userId,
    required String commentText,
  }) async {
    emit(PostsAddCommentLoading());
    print('add comment cubit called');
    final response = await _postsRepo.addComment(
      postId: postId,
      userId: userId,
      commentText: commentText,
    );
    response.fold(
      (failure) => emit(PostsAddCommentFailure(failure.errorMessage)),
      (_) => emit(PostsAddCommentSuccess()),
    );
  }

  // Add this inside your PostsCubit
  Future<void> addPost({
    required String userId,
    required String? content,
    List<String>? imageUrls,
  }) async {
    emit(PostsAddPostLoading());

    final response = await _postsRepo.addPost(
      userId: userId,
      content: content,
      imageUrls: imageUrls,
    );
    response.fold((failure) => emit(PostsAddPostFailure(failure.errorMessage)),
        (_) {
      emit(PostsGetAllPostsSuccess(allPosts));
    });
  }

  //Delete post
  Future<void> deletePost({required String postId}) async {
    emit(PostsDeletePostLoading());
    allPosts.removeWhere((p) => p.post.id == postId);
    emit(PostsGetAllPostsSuccess(allPosts));
    final response = await _postsRepo.deletePost(postId: postId);
    response.fold(
        (failure) => emit(PostsDeletePostFailure(failure.errorMessage)), (_) {
      emit(PostsGetAllPostsSuccess(allPosts));
      emit(PostsDeletePostSuccess());
    });
  }
}
