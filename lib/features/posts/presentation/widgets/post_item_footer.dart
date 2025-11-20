import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/functions/get_current_user.dart';
import 'package:leaptech_plus/core/utils/spacing.dart';
import 'package:leaptech_plus/features/posts/data/models/post_user_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_with_relation_model.dart';
import 'package:leaptech_plus/features/posts/presentation/cubits/posts_cubit.dart';
import 'package:leaptech_plus/features/posts/presentation/pages/comment_bottom_sheet.dart.dart';

class PostItemFooter extends StatefulWidget {
  final PostWithRelations postWithRelations;
  final PostUserModel currentUser;

  PostItemFooter({
    super.key,
    required this.postWithRelations,
    required this.currentUser,
  });

  @override
  State<PostItemFooter> createState() => _PostItemFooterState();
}

class _PostItemFooterState extends State<PostItemFooter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ❤️ Like button
        GestureDetector(
          onTap: () {
            context.read<PostsCubit>().toggleLike(
                  postId: widget.postWithRelations.post.id,
                  currentUser: widget.currentUser,
                );
            setState(() {
              widget.postWithRelations.likes.add(widget.currentUser);
            });
          },
          child: BlocBuilder<PostsCubit, PostsState>(
            builder: (context, state) {
              final cubit = context.read<PostsCubit>();
              final post = cubit.allPosts.firstWhere(
                (p) => p.post.id == widget.postWithRelations.post.id,
                orElse: () => widget.postWithRelations,
              );
              final isLiked =
                  post.likes.any((user) => user.id == getCurrentUser()!.id);
              return Row(
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_outline,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  horizontalSpace(4),
                  Text(
                    post.likes.length.toString(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        horizontalSpace(20),
        // 💬 Comment button
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: CommentBottomSheet(
                  comments: widget.postWithRelations.comments,
                ),
              ),
            );
          },
          child: Row(
            children: [
              const Icon(Icons.mode_comment_outlined, color: Colors.black54),
              horizontalSpace(4),
              Text(
                widget.postWithRelations.comments.length.toString(),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
