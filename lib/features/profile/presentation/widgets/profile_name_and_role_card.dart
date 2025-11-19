import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leaptech_plus/core/functions/get_current_date.dart';
import 'package:leaptech_plus/core/functions/get_current_user.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/core/widgets/app_button.dart';
import 'package:leaptech_plus/core/widgets/app_card.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';

class PorfileNameAndRoleCard extends StatelessWidget {
  const PorfileNameAndRoleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getCurrentUser();

    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: (user != null &&
                    user.imageUrl != null &&
                    user.imageUrl!.isNotEmpty)
                ? CachedNetworkImageProvider(user.imageUrl!)
                : null,
            child: (user == null ||
                    user.imageUrl == null ||
                    user.imageUrl!.isEmpty)
                ? Icon(
                    Icons.person,
                    size: 50.r,
                    color: Colors.white,
                  )
                : null,
          ),
          horizontalSpace(14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.fullName ?? 'No Name',
                style: AppTextStyles.font16WhiteBold,
              ),
              Text(
                user?.role ?? 'No Role',
                style: AppTextStyles.font14WhiteMedium,
              ),
            ],
          ),
          Spacer(),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
                size: 20.sp,
              ),
              onPressed: () {
                Hive.box<UserModel>('userBox').clear();
                context.pushReplacement('/loginScreen');
              },
            ),
          ),
        ],
      ),
    );
  }
}
