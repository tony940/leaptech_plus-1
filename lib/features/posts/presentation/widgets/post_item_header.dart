import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/features/posts/data/models/post_model.dart';

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
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
