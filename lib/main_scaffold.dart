import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:leaptech_plus/core/dependency_injection/dependency_injection.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/features/days_off/presentation/pages/days_off_screen.dart';
import 'package:leaptech_plus/features/home/presentation/pages/home_screen.dart';
import 'package:leaptech_plus/features/members/presentation/cubits/cubit/member_cubit.dart';
import 'package:leaptech_plus/features/members/presentation/pages/members_screen.dart';
import 'package:leaptech_plus/features/posts/presentation/pages/posts_screen.dart';
import 'package:leaptech_plus/features/profile/presentation/pages/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    DaysOffScreen(),
    PostsScreen(),
    BlocProvider(
      create: (context) => getIt<MemberCubit>(),
      child: MembersScreen(),
    ),
    ProfileScreen(),
  ];

  // Helper to get icon path
  String _getIcon(int index) {
    switch (index) {
      case 0:
        return 'assets/svgs/home.svg';
      case 1:
        return 'assets/svgs/meetings.svg';
      case 2:
        return 'assets/svgs/posts.svg';
      case 3:
        return 'assets/svgs/members.svg';
      case 4:
        return 'assets/svgs/profile.svg';

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'LeapTech+',
          style: AppTextStyles.font16WhiteBold,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.push('/supabaseTestScreen');
          },
          icon: Icon(
            Icons.bug_report,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey.shade300, // matches Scaffold to show curve
        index: _selectedIndex,
        color: AppColors.primaryColor,
        buttonBackgroundColor: AppColors.secondaryColor,
        height: 60.h,
        animationDuration: const Duration(milliseconds: 300),
        items: List.generate(5, (index) {
          return SvgPicture.asset(
            _getIcon(index),
            color:
                _selectedIndex == index ? Colors.white : Colors.grey.shade400,
            width: 24.w,
            height: 24.h,
          );
        }),
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
