import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/core/widgets/app_card.dart';

class DaysOffMainCard extends StatelessWidget {
  final Map<String, int>? balance;

  const DaysOffMainCard({super.key, this.balance});

  @override
  Widget build(BuildContext context) {
    // Default values if balance is not provided
    final sickRemaining = balance?['sickRemaining'] ?? 7;
    final personalRemaining = balance?['personalRemaining'] ?? 7;
    final annualRemaining = balance?['annualRemaining'] ?? 7;

    return AppCard(
      image: 'assets/images/home_intro.png',
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // SICK LEAVE
            Column(
              children: [
                Container(
                  width: 88.w,
                  height: 88.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.redAccent.withOpacity(.18),
                        Colors.redAccent.withOpacity(.10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(.25),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.medical_services_rounded,
                            color: Colors.redAccent, size: 26.sp),
                        verticalSpace(4),
                        Text(
                          "$sickRemaining/7",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(8),
                Text(
                  "Sick",
                  style: AppTextStyles.font14BlackMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),

            // PERSONAL LEAVE
            Column(
              children: [
                Container(
                  width: 88.w,
                  height: 88.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.shade700.withOpacity(.18),
                        Colors.amber.shade700.withOpacity(.10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.shade700.withOpacity(.25),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_rounded,
                            color: Colors.amber.shade700, size: 26.sp),
                        verticalSpace(4),
                        Text(
                          "$personalRemaining/7",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(8),
                Text(
                  "Personal",
                  style: AppTextStyles.font14BlackMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),

            // ANNUAL LEAVE
            Column(
              children: [
                Container(
                  width: 88.w,
                  height: 88.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(.18),
                        Colors.green.withOpacity(.10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(.25),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.beach_access_rounded,
                            color: Colors.green, size: 26.sp),
                        verticalSpace(4),
                        Text(
                          "$annualRemaining/7",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(8),
                Text(
                  "Annual",
                  style: AppTextStyles.font14BlackMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
