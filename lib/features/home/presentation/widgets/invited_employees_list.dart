import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/features/home/data/models/invited_employee_model.dart';

class InvitedEmployeesList extends StatelessWidget {
  final List<InvitedEmployeeModel> invitedEmployees;

  const InvitedEmployeesList({super.key, required this.invitedEmployees});

  @override
  Widget build(BuildContext context) {
    if (invitedEmployees.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpace(16),
          SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: invitedEmployees.length,
              itemBuilder: (context, index) {
                final employee = invitedEmployees[index];
                return _buildEmployeeItem(employee);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeItem(InvitedEmployeeModel employee) {
    return Container(
      width: 60.w,
      margin: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          // Employee avatar
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withOpacity(0.1),
              border: Border.all(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
            child: employee.imageUrl != null && employee.imageUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      employee.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                          size: 24.sp,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                    size: 24.sp,
                  ),
          ),
          verticalSpace(8),
          // Employee name with proper overflow handling
          Expanded(
            child: Text(
              employee.fullName,
              maxLines: 3,
              style: AppTextStyles.font12LightBlackWeight500,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
