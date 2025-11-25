import 'package:leaptech_plus/features/days_off/domain/entities/days_off_entity.dart';

abstract class DaysOffRepo {
  Future<List<DaysOffEntity>> getEmployeeDaysOff(String employeeId);
  Future<DaysOffEntity> requestDayOff(DaysOffEntity dayOff);
  Future<Map<String, int>> getEmployeeLeaveBalance(String employeeId);
}
