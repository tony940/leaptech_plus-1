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
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primaryColor,
          backgroundImage: postModel.user.imageUrl == null
              ? null
              : CachedNetworkImageProvider(postModel.user.imageUrl!),
        ),
        horizontalSpace(10),
        Text(
          postModel.user.fullName,
          style: AppTextStyles.font14BlackMedium,
        ),
        Spacer(),
        postModel.userId == getCurrentUser()!.id
            ? IconButton(
                onPressed: () {
                  final cubitContext = context; // capture parent context
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text('Delete Post'),
                        content:
                            Text('Are you sure you want to delete this post?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel',
                                style: AppTextStyles.font14BlackMedium),
                          ),
                          TextButton(
                            onPressed: () {
                              cubitContext.read<PostsCubit>().deletePost(
                                    postId: postModel.id,
                                  );
                              Navigator.pop(context);
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
              )
            : const SizedBox(),
      ],
    );
  }
}
