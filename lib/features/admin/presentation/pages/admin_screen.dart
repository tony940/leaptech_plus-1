import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/features/admin/presentation/widgets/admin_app_bar.dart';
import 'package:leaptech_plus/features/admin/presentation/widgets/glass_button.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          AdminAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                children: [
                  glassButton(
                    title: "Employees",
                    subTitle: "Manage Employees",
                    icon: Icons.people,
                    onTap: () {
                      context.push('/manageEmployeeScreen');
                    },
                  ),
                  verticalSpace(20),
                  glassButton(
                    title: "Events",
                    subTitle: "Manage Events",
                    icon: Icons.event_available,
                    onTap: () async {},
                  ),
                  verticalSpace(20),
                  glassButton(
                    title: "Days Off",
                    subTitle: "Manage Days Off",
                    icon: Icons.calendar_month,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
