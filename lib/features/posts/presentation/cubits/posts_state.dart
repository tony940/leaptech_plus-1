part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsGetAllPostsLoading extends PostsState {}

class PostsGetAllPostsSuccess extends PostsState {
  final List<PostWithRelations> posts;
  PostsGetAllPostsSuccess(this.posts);
}

class PostsGetAllPostsFailure extends PostsState {
  final String errorMessage;
  PostsGetAllPostsFailure(this.errorMessage);
}

// Toggle like states
class PostsToggleLikeLoading extends PostsState {}

class PostsToggleLikeFailure extends PostsState {
  final String postId;
  final String errorMessage;
  PostsToggleLikeFailure(this.postId, this.errorMessage);
}

class PostsToggleLikeSuccess extends PostsState {
  PostsToggleLikeSuccess();
}

// Add comment states
class PostsAddCommentLoading extends PostsState {}

class PostsAddCommentSuccess extends PostsState {}

class PostsAddCommentFailure extends PostsState {
  final String errorMessage;
  PostsAddCommentFailure(this.errorMessage);
}

//add post states
class PostsAddPostLoading extends PostsState {}

class PostsAddPostSuccess extends PostsState {}

class PostsAddPostFailure extends PostsState {
  final String errorMessage;
  PostsAddPostFailure(this.errorMessage);
}

//Delete post States
class PostsDeletePostLoading extends PostsState {}

class PostsDeletePostSuccess extends PostsState {}

class PostsDeletePostFailure extends PostsState {
  final String errorMessage;
  PostsDeletePostFailure(this.errorMessage);
}
