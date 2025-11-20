import 'package:leaptech_plus/features/posts/data/models/post_comment_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_user_model.dart';

// create copywithMethod
class PostWithRelations {
  final PostModel post;
  final List<PostCommentModel> comments;
  final List<PostUserModel> likes;
  final List<String> images;

  PostWithRelations({
    required this.post,
    required this.comments,
    required this.likes,
    required this.images,
  });

  // CopyWith method
  PostWithRelations copyWith({
    PostModel? post,
    List<PostCommentModel>? comments,
    List<PostUserModel>? likes,
    List<String>? images,
  }) {
    return PostWithRelations(
      post: post ?? this.post,
      comments: comments ?? List.from(this.comments),
      likes: likes ?? List.from(this.likes),
      images: images ?? List.from(this.images),
    );
  }
}
