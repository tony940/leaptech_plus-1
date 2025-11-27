import 'package:bloc/bloc.dart';
import 'package:leaptech_plus/features/admin/data/repo/admin_repo.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:meta/meta.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this._adminRepo) : super(AdminInitial());
  final AdminRepo _adminRepo;
  List<UserModel> allEmployees = [];

  getAllEmployees() async {
    emit(AdminGetAllEmployeeLoading());
    var res = await _adminRepo.getAllEmployees();
    res.fold((l) => emit(AdminGetAllEmployeeError(message: l.errorMessage)),
        (employees) {
      allEmployees = employees;
      emit(AdminGetAllEmployeeSuccess(employees: allEmployees));
    });
  }

  deleteEmployee({required String userId}) async {
    emit(AdminDeleteEmployeeLoading());
    var res = await _adminRepo.deleteEmployee(userId: userId);
    res.fold((l) => emit(AdminDeleteEmployeeError(message: l.errorMessage)),
        (r) {
      getAllEmployees();

      emit(
          AdminDeleteEmployeeSuccess(message: 'Employee deleted successfully'));
    });
  }

  registerEmployee({required UserModel user}) async {
    emit(AdminRegisterEmployeeLoading());
    var res = await _adminRepo.registerEmployee(user: user);
    res.fold((l) => emit(AdminRegisterEmployeeError(message: l.errorMessage)),
        (r) {
      emit(AdminRegisterEmployeeSuccess(
          message: 'Employee registered successfully'));
    });
  }

  updateEmployee({required UserModel user}) async {
    emit(AdminUpdateEmployeeLoading());
    var res = await _adminRepo.updateEmployee(user: user);
    res.fold((l) => emit(AdminUpdateEmployeeError(message: l.errorMessage)),
        (r) {
      emit(
          AdminUpdateEmployeeSuccess(message: 'Employee updated successfully'));
    });
  }
}
