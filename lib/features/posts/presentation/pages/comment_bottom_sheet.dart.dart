import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/functions/get_current_user.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/features/posts/data/models/post_comment_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_user_model.dart';
import 'package:leaptech_plus/features/posts/presentation/cubits/posts_cubit.dart';

class CommentBottomSheet extends StatefulWidget {
  const CommentBottomSheet(
      {super.key, required this.comments, required this.postId});

  final List<PostCommentModel> comments;
  final String postId;

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  bool isSendButtonActive = false;

  @override
  void initState() {
    _commentController.addListener(() {
      setState(() {
        isSendButtonActive = _commentController.text.isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag indicator
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Comments",
                  style: AppTextStyles.font18BlackBold,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Comments list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              itemCount: widget.comments.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final comment = widget.comments[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                      child: CircleAvatar(
                              radius: 18.r,
                              backgroundImage:
                                  NetworkImage(comment.user.imageUrl),
                            ),
                    ),
                    horizontalSpace(10),
                    // Comment bubble
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.user.fullName ?? "",
                              style: AppTextStyles.font14BlackMedium.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              comment.content ?? "",
                              style: AppTextStyles.font14BlackMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          Divider(height: 1),

          // Input bar
          SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Text field
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: "Add a comment...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Send button
                  GestureDetector(
                    onTap: () {
                      if (_commentController.text.isNotEmpty) {
                        context.read<PostsCubit>().addComment(
                              postId: widget.postId.toString(),
                              userId: getCurrentUser()!.id,
                              commentText: _commentController.text,
                            );
                        if (context.read<PostsCubit>().state
                            is PostsAddCommentSuccess) {}
                        setState(() {
                          widget.comments.add(
                            PostCommentModel(
                              id: '',
                              createdAt: DateTime.now(),
                              postId: widget.postId,
                              userId: getCurrentUser()!.id,
                              content: _commentController.text,
                              user: PostUserModel(
                                id: getCurrentUser()!.id,
                                fullName: getCurrentUser()!.fullName,
                                imageUrl: getCurrentUser()!.imageUrl!,
                              ),
                            ),
                          );
                        });
                      }
                      _commentController.clear();
                    },
                    child: BlocBuilder<PostsCubit, PostsState>(
                      buildWhen: (previous, current) =>
                          current is PostsAddCommentLoading ||
                          current is PostsAddCommentSuccess ||
                          current is PostsAddCommentFailure,
                      builder: (context, state) {
                        if (state is PostsAddCommentLoading) {
                          return const CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          );
                        } else {
                          return CircleAvatar(
                            radius: 22.r,
                            backgroundColor: isSendButtonActive
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                            child: const Icon(Icons.send_rounded,
                                color: Colors.white, size: 20),
                          );
                        }
                      },
                    ),
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
