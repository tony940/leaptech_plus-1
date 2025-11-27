import 'package:flutter/material.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';

Widget glassButton({
  required String title,
  required String subTitle,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 1, end: 1),
    duration: const Duration(milliseconds: 300),
    builder: (context, scale, child) {
      return GestureDetector(
        onTapDown: (_) {},
        onTapUp: (_) {},
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Transform.scale(
            scale: scale,
            child: Container(
              height: 135,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.75),
                    Colors.white.withOpacity(0.30),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.08),
                    blurRadius: 25,
                    spreadRadius: 2,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Icon Circle
                  Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor,
                          AppColors.primaryColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryColor,
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 30, color: Colors.white),
                  ),

                  const SizedBox(width: 25),

                  // Text Column
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.1,
                        ),
                      ),
                      verticalSpace(8),
                      Text(
                        subTitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
