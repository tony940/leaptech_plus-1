import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/core/themes/app_text_styles.dart';
import 'package:leaptech_plus/core/utils/my_toast.dart';
import 'package:leaptech_plus/core/widgets/app_card.dart';
import 'package:leaptech_plus/features/posts/data/models/post_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_user_model.dart';
import 'package:leaptech_plus/features/posts/data/models/post_with_relation_model.dart';
import 'package:leaptech_plus/features/posts/presentation/cubits/posts_cubit.dart';
import 'package:leaptech_plus/features/posts/presentation/widgets/post_item.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PostsScreenBody extends StatefulWidget {
  const PostsScreenBody({
    super.key,
  });

  @override
  State<PostsScreenBody> createState() => _PostsScreenBodyState();
}

class _PostsScreenBodyState extends State<PostsScreenBody> {
  @override
  void initState() {
    context.read<PostsCubit>().getAllPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppCard(
          child: Text(
            'What\'s new',
            style: AppTextStyles.font16WhiteBold,
          ),
        ),
        BlocConsumer<PostsCubit, PostsState>(
          listener: (context, state) {
            if (state is PostsDeletePostFailure ||
                state is PostsDeleteCommentFailure ||
                state is PostsAddCommentFailure ||
                state is PostsAddPostFailure ||
                state is PostsToggleLikeFailure) {
              MyToast.error(context, 'Something went wrong. Please try again.');
            }
          },
          buildWhen: (previous, current) =>
              current is PostsGetAllPostsSuccess ||
              current is PostsGetAllPostsFailure ||
              current is PostsGetAllPostsLoading,
          builder: (context, state) {
            if (state is PostsGetAllPostsLoading) {
              return _buildLoadingPosts();
            }
            if (state is PostsGetAllPostsSuccess) {
              if (state.posts.isEmpty) {
                return _buildPostsEmpty();
              } else {
                return _buildPostsLoadedSuccess(context, state);
              }
            }
            if (state is PostsGetAllPostsFailure) {
              return _buildPostsFailure(state, context);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  _buildPostsFailure(PostsGetAllPostsFailure state, BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(state.errorMessage),
          ElevatedButton(
            onPressed: () {
              context.read<PostsCubit>().getAllPosts();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  _buildPostsLoadedSuccess(
      BuildContext context, PostsGetAllPostsSuccess state) {
    return Expanded(
      child: RefreshIndicator(
        color: AppColors.primaryColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          context.read<PostsCubit>().getAllPosts();
        },
        child: ListView.builder(
          itemCount: state.posts.length,
          itemBuilder: (context, index) {
            return PostItem(postWithRelation: state.posts[index]);
          },
        ),
      ),
    );
  }

  _buildPostsEmpty() {
    return Expanded(
      child: RefreshIndicator(
        color: AppColors.primaryColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          context.read<PostsCubit>().getAllPosts();
        },
        child: ListView(
          children: [
            LottieBuilder.asset(
              'assets/animations/empty.json',
              width: 400.w,
              height: 400.h,
            ),
            Center(
              child: Text(
                'No posts yet',
                style: AppTextStyles.font14BlackRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildLoadingPosts() {
    return Expanded(
      child: Skeletonizer(
        enabled: true,
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return PostItem(
              postWithRelation: PostWithRelations(
                post: PostModel(
                    id: 'id',
                    userId: 'userId',
                    createdAt: DateTime.now(),
                    user: PostUserModel(
                        id: 'id',
                        fullName: 'fullName',
                        imageUrl:
                            'https://fastly.picsum.photos/id/230/200/300.jpg?hmac=pyhlpgJN2oBeEzhJbnJYrCsLoJM6MKd_NUQGIQhVx5k')),
                comments: [],
                likes: [],
                images: [],
              ),
            );
          },
        ),
      ),
    );
  }
}
