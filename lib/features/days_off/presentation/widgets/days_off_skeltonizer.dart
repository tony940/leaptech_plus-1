import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/features/days_off/presentation/widgets/day_off_list_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DaysOffSkeleton extends StatelessWidget {
  const DaysOffSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Skeletonizer(
            enabled: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DayOffLIstItem(
                  item: {
                    'name': 'John Doe',
                    'date': '12/12/2022',
                    'status': 'pending'
                  },
                  statusColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
