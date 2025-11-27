part of 'admin_cubit.dart';

@immutable
sealed class AdminState {}

final class AdminInitial extends AdminState {}

final class AdminGetAllEmployeeLoading extends AdminState {}

final class AdminGetAllEmployeeSuccess extends AdminState {
  final List<UserModel> employees;

  AdminGetAllEmployeeSuccess({required this.employees});
}

final class AdminGetAllEmployeeError extends AdminState {
  final String message;

  AdminGetAllEmployeeError({required this.message});
}

final class AdminDeleteEmployeeLoading extends AdminState {}

final class AdminDeleteEmployeeSuccess extends AdminState {
  final String message;

  AdminDeleteEmployeeSuccess({required this.message});
}

final class AdminDeleteEmployeeError extends AdminState {
  final String message;

  AdminDeleteEmployeeError({required this.message});
}

final class AdminRegisterEmployeeLoading extends AdminState {}

final class AdminRegisterEmployeeSuccess extends AdminState {
  final String message;

  AdminRegisterEmployeeSuccess({required this.message});
}

final class AdminRegisterEmployeeError extends AdminState {
  final String message;

  AdminRegisterEmployeeError({required this.message});
}

final class AdminUpdateEmployeeLoading extends AdminState {}

final class AdminUpdateEmployeeSuccess extends AdminState {
  final String message;

  AdminUpdateEmployeeSuccess({required this.message});
}

final class AdminUpdateEmployeeError extends AdminState {
  final String message;

  AdminUpdateEmployeeError({required this.message});
}
