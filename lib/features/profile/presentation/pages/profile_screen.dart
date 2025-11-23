import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/core/widgets/app_button.dart';
import 'package:leaptech_plus/core/widgets/app_card.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:leaptech_plus/features/profile/presentation/widgets/performance_card.dart';
import 'package:leaptech_plus/features/profile/presentation/widgets/profile_name_and_role_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PorfileNameAndtitleCard(),
        verticalSpace(20),
        Text(
          "Sabri's performances",
          style: AppTextStyles.font18BlackSemiBold,
        ),
        verticalSpace(10),
        const PerformanceCard(),
      ],
    );
  }
}
