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
