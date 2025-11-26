import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/functions/get_current_user.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/features/posts/data/models/post_model.dart';
import 'package:leaptech_plus/features/posts/presentation/cubits/posts_cubit.dart';

class PostItemHeader extends StatelessWidget {
  const PostItemHeader({super.key, required this.postModel});
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    final currentUser = getCurrentUser();

    // If user not loaded, hide delete button
    if (currentUser == null) {
      return _buildHeader(context, showDeleteButton: false);
    }

    // Check if current user is author or admin
    final isAuthorOrAdmin = (postModel.userId.isNotEmpty &&
            postModel.userId == currentUser.id) ||
        (currentUser.type.trim().toLowerCase() == 'admin');

    return _buildHeader(context, showDeleteButton: isAuthorOrAdmin);
  }

  Widget _buildHeader(BuildContext context, {required bool showDeleteButton}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primaryColor,
          backgroundImage: CachedNetworkImageProvider(postModel.user.imageUrl),
        ),
        horizontalSpace(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postModel.user.fullName,
              style: AppTextStyles.font14BlackMedium,
            ),
            Text(
              '${postModel.createdAt.day}/${postModel.createdAt.month}/${postModel.createdAt.year} at ${postModel.createdAt.hour}:${postModel.createdAt.minute.toString().padLeft(2, '0')}',
              style: AppTextStyles.font12LightBlackWeight500,
            ),
          ],
        ),
        Spacer(),
        if (showDeleteButton)
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text('Delete Post'),
                    content: Text('Are you sure you want to delete this post?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text('Cancel',
                            style: AppTextStyles.font14BlackMedium),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<PostsCubit>().deletePost(
                                postId: postModel.id,
                              );
                          Navigator.pop(dialogContext);
                        },
                        child: Text(
                          'Delete',
                          style: AppTextStyles.font14BlackMedium
                              .copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 20.sp,
            ),
          ),
      ],
    );
  }
}
