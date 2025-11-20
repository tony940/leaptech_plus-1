import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/functions/get_current_date.dart';
import 'package:leaptech_plus/core/functions/get_current_user.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/features/posts/data/models/post_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_user_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_with_relation_model.dart';
import 'package:leaptech_plus/features/posts/presentation/widgets/post_item_footer.dart';
import 'package:leaptech_plus/features/posts/presentation/widgets/post_item_header.dart';
import 'package:leaptech_plus/features/posts/presentation/widgets/post_item_image.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.postWithRelation,
  });
  final PostWithRelations postWithRelation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      margin: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          PostItemHeader(
            postModel: postWithRelation.post,
          ),
          Divider(),
          // Post text
          Text(
            postWithRelation.post.content ?? '',
            style: AppTextStyles.font12BlackRegular,
          ),
          PostItemImage(
            images: postWithRelation.images,
          ),
          Divider(),
          // Post footer
          PostItemFooter(
            postWithRelations: postWithRelation,
            currentUser: PostUserModel(
              id: getCurrentUser()!.id,
              fullName: getCurrentUser()!.fullName,
              imageUrl: getCurrentUser()!.imageUrl!,
            ),
          ),
        ],
      ),
    );
  }
}
