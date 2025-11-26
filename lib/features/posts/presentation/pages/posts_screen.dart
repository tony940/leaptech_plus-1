import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leaptech_plus/core/dependency_injection/dependency_injection.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/features/posts/presentation/cubits/posts_cubit.dart';
import 'package:leaptech_plus/features/posts/presentation/widgets/posts_screen_body.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<PostsCubit>(),
        child: PostsScreenBody(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryColor,
        shape: CircleBorder(),
        onPressed: () {
          context.push('/addPostScreen');
        },
        child: Icon(
          Icons.add,
          size: 20.sp,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
