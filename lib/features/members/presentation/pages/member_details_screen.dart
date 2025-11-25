import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';

class MemberDetailsScreen extends StatelessWidget {
  final UserModel member;

  const MemberDetailsScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          member.fullName,
          style: AppTextStyles.font16BlackSemiBold,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            /// ---------------- PROFILE IMAGE ----------------
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: (member.imageUrl != null && member.imageUrl!.isNotEmpty)
                  ? Hero(
                      tag: member.id,
                      child: CircleAvatar(
                        radius: 60.r,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage:
                            CachedNetworkImageProvider(member.imageUrl!),
                      ),
                    )
                  : CircleAvatar(
                      radius: 60.r,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(
                        Icons.person,
                        size: 50.r,
                        color: AppColors.primaryColor,
                      ),
                    ),
            ),

            verticalSpace(20),

            /// ---------------- NAME + TITLE ----------------
            Text(
              member.fullName,
              style: AppTextStyles.font20BlackBold.copyWith(
                fontSize: 22.sp,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(6),
            Text(
              member.title,
              style: AppTextStyles.font14BlackMedium.copyWith(
                color: Colors.grey.shade600,
              ),
            ),

            verticalSpace(30),

            /// ---------------- MODERN GLASS CARD ----------------
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    spreadRadius: 1,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // _buildInfoRow(Icons.phone, "Phone", member.phone ?? "N/A"),
                  // verticalSpace(14),
                  _buildInfoRow(Icons.email, "Email", member.email ?? "N/A"),
                  verticalSpace(14),
                  _buildInfoRow(Icons.phone, "phone", member.phone ?? "N/A"),
                  verticalSpace(14),
                  _buildInfoRow(Icons.badge, "Role", member.title),
                  verticalSpace(14),
                  _buildInfoRow(
                      Icons.home_work_sharp, "Branch", member.branch ?? "N/A"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- Reusable info row widget ----------------
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 22.r),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.font14BlackMedium.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              verticalSpace(3),
              Text(
                value,
                style: AppTextStyles.font16BlackSemiBold,
              ),
            ],
          ),
        )
      ],
    );
  }
}
