import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';

class EventDetailsAppBar extends StatelessWidget {
  const EventDetailsAppBar({
    super.key, required this.eventName,
  });
final String eventName;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180.h,
      pinned: true,
      backgroundColor: AppColors.primaryColor,
      leading: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryColor,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryColor,
                    AppColors.secondaryColor,
                    AppColors.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Pattern Overlay
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 30.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: AppTextStyles.font28WhiteBold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
