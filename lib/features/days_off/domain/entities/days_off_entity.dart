class DaysOffEntity {
  final String id;
  final String employeeId;
  final String leaveType; // Sick, Personal, Annual
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String status; // Pending, Approved, Rejected
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  DaysOffEntity({
    required this.id,
    required this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.status,
    this.attachmentUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'leave_type': leaveType,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'description': description,
      'status': status,
      'attachment_url': attachmentUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
