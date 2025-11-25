import 'package:flutter_test/flutter_test.dart';
import 'package:leaptech_plus/features/days_off/domain/entities/days_off_entity.dart';

void main() {
  group('DaysOffEntity', () {
    test('should create entity with correct values', () {
      final now = DateTime.now();
      final entity = DaysOffEntity(
        id: '123',
        employeeId: 'emp123',
        leaveType: 'Sick',
        startDate: now,
        endDate: now.add(Duration(days: 1)),
        description: 'Feeling unwell',
        status: 'Pending',
        createdAt: now,
        updatedAt: now,
      );

      expect(entity.id, '123');
      expect(entity.employeeId, 'emp123');
      expect(entity.leaveType, 'Sick');
      expect(entity.status, 'Pending');
    });

    test('should convert to JSON correctly', () {
      final now = DateTime.now();
      final entity = DaysOffEntity(
        id: '123',
        employeeId: 'emp123',
        leaveType: 'Sick',
        startDate: now,
        endDate: now.add(Duration(days: 1)),
        description: 'Feeling unwell',
        status: 'Pending',
        createdAt: now,
        updatedAt: now,
      );

      final json = entity.toJson();
      expect(json['id'], '123');
      expect(json['employee_id'], 'emp123');
      expect(json['leave_type'], 'Sick');
      expect(json['status'], 'Pending');
    });
  });
}
