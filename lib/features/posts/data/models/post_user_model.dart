class PostUserModel {
  final String id;
  final String fullName;
  final String imageUrl;

  PostUserModel({
    required this.id,
    required this.fullName,
    required this.imageUrl,
  });

  factory PostUserModel.fromMap(Map<String, dynamic> map) {
    return PostUserModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String,
      imageUrl: map['image_url'] as String,
    );
  }

  PostUserModel copy() {
    return PostUserModel(
      id: id,
      fullName: fullName,
      imageUrl: imageUrl,
    );
  }
}
