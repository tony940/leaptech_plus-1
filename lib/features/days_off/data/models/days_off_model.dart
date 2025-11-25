import 'package:leaptech_plus/features/days_off/domain/entities/days_off_entity.dart';

class DaysOffModel extends DaysOffEntity {
  DaysOffModel({
    required super.id,
    required super.employeeId,
    required super.leaveType,
    required super.startDate,
    required super.endDate,
    required super.description,
    required super.status,
    super.attachmentUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DaysOffModel.fromJson(Map<String, dynamic> json) {
    return DaysOffModel(
      id: json['id'],
      employeeId: json['employee_id'],
      leaveType: json['leave_type'],
      startDate: DateTime.parse(json['start_date']).toLocal(),
      endDate: DateTime.parse(json['end_date']).toLocal(),
      description: json['description'] ?? '',
      status: json['status'],
      attachmentUrl: json['attachment_url'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      updatedAt: DateTime.parse(json['updated_at']).toLocal(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
