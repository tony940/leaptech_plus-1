import 'package:hive/hive.dart';

part 'user_model.g.dart'; // generated file

@HiveType(typeId: 0) // assign a unique typeId for each model
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String? imageUrl;
  @HiveField(6)
  final String type;

  @HiveField(7)
  final String? phone;

  @HiveField(8)
  final String? branch;

  UserModel(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.password,
      required this.title,
      this.imageUrl,
      required this.type,
      this.phone,
      this.branch});

  /// Factory constructor from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      password: json['password'],
      title: json['title'],
      imageUrl: json['image_url'],
      type: json['type'],
      phone: json['phone'],
      branch: json['branch'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'password': password,
        'title': title,
        'image_url': imageUrl,
        'type': type,
        'phone': phone,
      };
}
