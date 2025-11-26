import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';

class DayOffLIstItem extends StatelessWidget {
  const DayOffLIstItem({
    super.key,
    required this.item,
    required this.statusColor,
  });

  final Map<String, String> item;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(14.r),
        gradient: LinearGradient(colors: [
          AppColors.secondaryColor,
          AppColors.primaryColor,
        ]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEAVE NAME & STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item["name"]!,
                style: AppTextStyles.font16WhiteBold.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  item["status"]!,
                  style: AppTextStyles.font16WhiteBold.copyWith(
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(8),

          // DURATION
          Text(
            "Duration: ${item["duration"]}",
            style: AppTextStyles.font14BlackMedium,
          ),
          verticalSpace(4),

          // START & END
          Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 16.sp, color: AppColors.primaryColor),
              horizontalSpace(4),
              Text(
                "Start: ${item["start"]}",
                style: AppTextStyles.font14BlackMedium,
              ),
              horizontalSpace(12),
              Icon(Icons.calendar_today,
                  size: 16.sp, color: AppColors.primaryColor),
              horizontalSpace(4),
              Text(
                "End: ${item["end"]}",
                style: AppTextStyles.font14BlackMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
