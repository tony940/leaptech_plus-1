part of 'days_off_cubit.dart';

@immutable
abstract class DaysOffState {}

class DaysOffInitial extends DaysOffState {}

class DaysOffLoading extends DaysOffState {}

class DaysOffLoaded extends DaysOffState {
  final List<DaysOffEntity> daysOff;

  DaysOffLoaded(this.daysOff);
}

class DaysOffError extends DaysOffState {
  final String message;

  DaysOffError(this.message);
}

class DaysOffRequestLoading extends DaysOffState {}

class DaysOffRequestSuccess extends DaysOffState {
  final DaysOffEntity dayOff;

  DaysOffRequestSuccess(this.dayOff);
}

class DaysOffRequestError extends DaysOffState {
  final String message;

  DaysOffRequestError(this.message);
}

class LeaveBalanceLoading extends DaysOffState {}

class LeaveBalanceLoaded extends DaysOffState {
  final Map<String, int> balance;

  LeaveBalanceLoaded(this.balance);
}

class LeaveBalanceError extends DaysOffState {
  final String message;

  LeaveBalanceError(this.message);
}
