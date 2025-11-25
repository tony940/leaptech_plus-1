class InvitedEmployeeModel {
  final String id;
  final String fullName;
  final String? imageUrl;

  InvitedEmployeeModel({
    required this.id,
    required this.fullName,
    this.imageUrl,
  });

  factory InvitedEmployeeModel.fromMap(Map<String, dynamic> map) {
    return InvitedEmployeeModel(
      id: map['id'],
      fullName: map['full_name'],
      imageUrl: map['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'image_url': imageUrl,
    };
  }
}