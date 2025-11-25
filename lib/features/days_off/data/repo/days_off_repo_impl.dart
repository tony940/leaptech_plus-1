import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/features/days_off/data/models/days_off_model.dart';
import 'package:leaptech_plus/features/days_off/domain/entities/days_off_entity.dart';
import 'package:leaptech_plus/features/days_off/domain/repo/days_off_repo.dart';

class DaysOffRepoImpl implements DaysOffRepo {
  final SupabaseService _supabaseService;

  DaysOffRepoImpl(this._supabaseService);

  @override
  Future<List<DaysOffEntity>> getEmployeeDaysOff(String employeeId) async {
    try {
      final response = await _supabaseService.client
          .from('days_off')
          .select()
          .eq('employee_id', employeeId)
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data
          .map((e) => DaysOffModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DaysOffEntity> requestDayOff(DaysOffEntity dayOff) async {
    try {
      final model = DaysOffModel(
        id: dayOff.id,
        employeeId: dayOff.employeeId,
        leaveType: dayOff.leaveType,
        startDate: dayOff.startDate,
        endDate: dayOff.endDate,
        description: dayOff.description,
        status: dayOff.status,
        attachmentUrl: dayOff.attachmentUrl,
        createdAt: dayOff.createdAt,
        updatedAt: dayOff.updatedAt,
      );

      final response = await _supabaseService.client
          .from('days_off')
          .insert(model.toJson())
          .select()
          .single();

      return DaysOffModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, int>> getEmployeeLeaveBalance(String employeeId) async {
    try {
      // Get all approved days off for this employee grouped by type
      final response = await _supabaseService.client
          .from('days_off')
          .select('leave_type, start_date, end_date')
          .eq('employee_id', employeeId)
          .eq('status', 'Approved');

      final data = response as List<dynamic>;

      // Calculate used days for each type
      int sickUsed = 0;
      int personalUsed = 0;
      int annualUsed = 0;

      for (var item in data) {
        final Map<String, dynamic> leave = item as Map<String, dynamic>;
        final startDate = DateTime.parse(leave['start_date']);
        final endDate = DateTime.parse(leave['end_date']);

        // Calculate duration (inclusive of both start and end dates)
        final duration = endDate.difference(startDate).inDays + 1;

        switch (leave['leave_type']) {
          case 'Sick':
            sickUsed += duration;
            break;
          case 'Personal':
            personalUsed += duration;
            break;
          case 'Annual':
            annualUsed += duration;
            break;
        }
      }

      // Each type has 7 days allowance per year
      return {
        'sickRemaining': 7 - sickUsed,
        'personalRemaining': 7 - personalUsed,
        'annualRemaining': 7 - annualUsed,
      };
    } catch (e) {
      rethrow;
    }
  }
}
