import 'package:bloc/bloc.dart';
import 'package:leaptech_plus/features/days_off/domain/entities/days_off_entity.dart';
import 'package:leaptech_plus/features/days_off/domain/repo/days_off_repo.dart';
import 'package:meta/meta.dart';

part 'days_off_state.dart';

class DaysOffCubit extends Cubit<DaysOffState> {
  final DaysOffRepo _daysOffRepo;
  String? _currentEmployeeId;

  DaysOffCubit(this._daysOffRepo) : super(DaysOffInitial());

  void setCurrentEmployeeId(String employeeId) {
    _currentEmployeeId = employeeId;
  }

  Future<void> getEmployeeDaysOff(String employeeId) async {
    _currentEmployeeId = employeeId;
    emit(DaysOffLoading());
    try {
      final daysOff = await _daysOffRepo.getEmployeeDaysOff(employeeId);
      emit(DaysOffLoaded(daysOff));
    } catch (e) {
      emit(DaysOffError(e.toString()));
    }
  }

  Future<void> requestDayOff(DaysOffEntity dayOff) async {
    emit(DaysOffRequestLoading());
    try {
      final requestedDayOff = await _daysOffRepo.requestDayOff(dayOff);
      emit(DaysOffRequestSuccess(requestedDayOff));

      // Automatically refresh the days off list after successful request
      if (_currentEmployeeId != null) {
        await getEmployeeDaysOff(_currentEmployeeId!);
      }
    } catch (e) {
      emit(DaysOffRequestError(e.toString()));
    }
  }

  Future<void> getEmployeeLeaveBalance(String employeeId) async {
    emit(LeaveBalanceLoading());
    try {
      final balance = await _daysOffRepo.getEmployeeLeaveBalance(employeeId);
      emit(LeaveBalanceLoaded(balance));
    } catch (e) {
      if (isClosed) return;
      emit(LeaveBalanceError(e.toString()));
    }
  }
}
