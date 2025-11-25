import 'package:leaptech_plus/features/posts/data/models/post_user_model.dart';

class PostModel {
  final String id;
  final String userId;
  final String? content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final PostUserModel user;

  PostModel({
    required this.id,
    required this.userId,
    this.content,
    required this.createdAt,
    this.updatedAt,
    required this.user,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      content: map['content'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String).toLocal()
          : null,
      user: PostUserModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  PostModel copy({
    String? id,
    String? userId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    PostUserModel? user,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user.copy(),
    );
  }
}
