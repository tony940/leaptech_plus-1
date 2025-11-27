import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/core/widgets/app_button.dart';
import 'package:leaptech_plus/features/admin/presentation/cubits/cubit/admin_cubit.dart';
import 'package:leaptech_plus/features/admin/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:leaptech_plus/features/admin/presentation/widgets/employee_form_sheet.dart';
import 'package:leaptech_plus/features/admin/presentation/widgets/employee_list_tile.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';

class ManageEmployeeScreen extends StatefulWidget {
  const ManageEmployeeScreen({super.key});

  @override
  State<ManageEmployeeScreen> createState() => _ManageEmployeeScreenState();
}

class _ManageEmployeeScreenState extends State<ManageEmployeeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().getAllEmployees();
  }

  void _showEmployeeFormSheet(BuildContext context, [UserModel? employee]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext sheetContext) {
        return EmployeeFormSheet(
          employee: employee,
          onSave: (user) {
            if (employee != null) {
              // Update existing employee
              context.read<AdminCubit>().updateEmployee(user: user);
            } else {
              // Add new employee
              context.read<AdminCubit>().registerEmployee(user: user);
            }
            Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }

  void _deleteEmployee(BuildContext context, String userId, String fullName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return DeleteConfirmationDialog(
          employeeName: fullName,
          onConfirm: () {
            context.read<AdminCubit>().deleteEmployee(userId: userId);
          },
        );
      },
    );
  }

  void _refreshEmployeeList() {
    // Add a small delay to ensure the operation completes
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<AdminCubit>().getAllEmployees();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Employees'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: BlocConsumer<AdminCubit, AdminState>(
        listener: (context, state) {
          // Handle success states to trigger refresh
          if (state is AdminDeleteEmployeeSuccess ||
              state is AdminRegisterEmployeeSuccess ||
              state is AdminUpdateEmployeeSuccess) {
            _refreshEmployeeList();
          }

          // Handle error states
          if (state is AdminGetAllEmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is AdminDeleteEmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is AdminRegisterEmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is AdminUpdateEmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminGetAllEmployeeLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ));
          } else if (state is AdminGetAllEmployeeSuccess) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () => _showEmployeeFormSheet(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.employees.isEmpty
                      ? const Center(
                          child: Text(
                            'No employees available',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.employees.length,
                          itemBuilder: (context, index) {
                            final employee = state.employees[index];
                            return EmployeeListTile(
                              employee: employee,
                              onEdit: () =>
                                  _showEmployeeFormSheet(context, employee),
                              onDelete: () => _deleteEmployee(
                                  context, employee.id, employee.fullName),
                            );
                          },
                        ),
                ),
              ],
            );
          } else if (state is AdminGetAllEmployeeError) {
            return Center(
              child: Padding(
                padding: EdgeInsetsGeometry.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    verticalSpace(20),
                    AppButton(
                      buttonText: 'Retry',
                      onPressed: () =>
                          context.read<AdminCubit>().getAllEmployees(),
                      backgroundColor: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
