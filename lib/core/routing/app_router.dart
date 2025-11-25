import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leaptech_plus/core/dependency_injection/dependency_injection.dart';
import 'package:leaptech_plus/core/widgets/custom_photo_view.dart';
import 'package:leaptech_plus/features/days_off/presentation/cubits/days_off_cubit.dart';
import 'package:leaptech_plus/features/days_off/presentation/pages/request_day_off_screen.dart';
import 'package:leaptech_plus/features/home/data/models/event_model.dart';
import 'package:leaptech_plus/features/home/presentation/cubits/cubit/home_cubit.dart';
import 'package:leaptech_plus/features/home/presentation/pages/event_details_screen.dart';
import 'package:leaptech_plus/features/home/presentation/widgets/request_day_off_button.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:leaptech_plus/features/login/presentation/cubits/cubit/login_cubit.dart';
import 'package:leaptech_plus/features/login/presentation/pages/login_screen.dart';
import 'package:leaptech_plus/features/members/presentation/pages/member_details_screen.dart';
import 'package:leaptech_plus/features/posts/presentation/cubits/posts_cubit.dart';
import 'package:leaptech_plus/features/posts/presentation/pages/add_post_screen.dart';
import 'package:leaptech_plus/features/splash/presentation/pages/splash_screen.dart';
import 'package:leaptech_plus/main_scaffold.dart';
import 'package:leaptech_plus/supabase_test_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Get the saved user from Hive
      final userBox = Hive.box<UserModel>('userBox');
      final currentUser = userBox.get('currentUser');

      // If user is on splash screen, decide where to go
      if (state.matchedLocation == '/') {
        return currentUser != null ? '/mainScaffold' : '/loginScreen';
      }
      if (currentUser == null) {
        return '/loginScreen';
      } else {
        return null;
      }
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/loginScreen',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<LoginCubit>(),
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/mainScaffold',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<HomeCubit>(),
          child: MainScaffold(),
        ),
      ),
      GoRoute(
        path: '/requestDayOffScren',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<DaysOffCubit>(),
          child: RequestDayOffScreen(),
        ),
      ),
      GoRoute(
        path: '/addPostScreen',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<PostsCubit>(),
          child: AddPostScreen(),
        ),
      ),
      GoRoute(
        path: '/eventDetailsScreen',
        builder: (context, state) {
          var event = state.extra as EventModel;
          return EventDetailsScreen(event: event);
        },
      ),
      GoRoute(
        path: '/supabaseTestScreen',
        builder: (context, state) {
          return SupabaseTestScreen();
        },
      ),
      GoRoute(
        path: '/customPhotoView',
        builder: (context, state) {
          var imageUrl = state.extra as String;
          return CustomPhotoView(
            imageUrl: imageUrl,
          );
        },
      ),
      GoRoute(
        path: '/memberDetailsScreen',
        builder: (context, state) {
          var member = state.extra as UserModel;
          return MemberDetailsScreen(
            member: member,
          );
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
