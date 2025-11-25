import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/features/members/presentation/cubits/cubit/member_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().getAllMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.85)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'LeapTech',
              style: AppTextStyles.font20BlackBold
                  .copyWith(letterSpacing: 0.5, color: Colors.white),
            ),
          ),
        ),

        verticalSpace(16),

        /// Body Section
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('All Members', style: AppTextStyles.font16BlackSemiBold),
                verticalSpace(12),
                Expanded(
                  child: BlocBuilder<MemberCubit, MemberState>(
                    builder: (context, state) {
                      if (state is MemberLoadingState) {
                        return _buildLoadingList();
                      }
                      if (state is MemberLoadedFailureState) {
                        return _buildError(state);
                      }
                      if (state is MemberLoadedSuccessState) {
                        return _buildMemberList(state);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ---------------- ERROR ----------------
  Widget _buildError(MemberLoadedFailureState state) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 48.r),
            verticalSpace(16),
            Text(
              "Oops!",
              style: AppTextStyles.font18BlackSemiBold,
            ),
            verticalSpace(8),
            Text(
              state.errMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14BlackMedium
                  .copyWith(color: Colors.red.shade700),
            ),
            verticalSpace(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<MemberCubit>().getAllMembers();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "Try Again",
                  style: AppTextStyles.font16WhiteBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- MEMBER LIST ----------------
  Widget _buildMemberList(MemberLoadedSuccessState state) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 16.h),
      itemCount: state.members.length,
      separatorBuilder: (_, __) => verticalSpace(12),
      itemBuilder: (context, index) {
        final member = state.members[index];
        final imageUrl = member.imageUrl;

        return GestureDetector(
          onTap: () => context.push('/memberDetailsScreen', extra: member),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                // Profile Image with Hero
                (imageUrl != null && imageUrl.isNotEmpty)
                    ? Hero(
                        tag: member.id,
                        child: CircleAvatar(
                          radius: 28.r,
                          backgroundImage: CachedNetworkImageProvider(imageUrl),
                        ),
                      )
                    : CircleAvatar(
                        radius: 28.r,
                        backgroundColor: Colors.grey.shade300,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 28.r),
                      ),
                horizontalSpace(16),
                // Name & Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.fullName,
                          style: AppTextStyles.font16BlackSemiBold),
                      verticalSpace(4),
                      Text(
                        member.title,
                        style: AppTextStyles.font14BlackMedium
                            .copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 16.sp, color: Colors.grey.shade400),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ---------------- LOADING ----------------
  Widget _buildLoadingList() {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: 6,
        separatorBuilder: (_, __) => verticalSpace(12),
        itemBuilder: (_, __) {
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 28.r, backgroundColor: Colors.grey.shade300),
                horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 14.h,
                          width: 140.w,
                          color: Colors.grey.shade300),
                      verticalSpace(6),
                      Container(
                          height: 12.h,
                          width: 100.w,
                          color: Colors.grey.shade300),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
