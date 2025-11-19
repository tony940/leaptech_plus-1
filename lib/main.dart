import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leaptech_plus/core/dependency_injection/dependency_injection.dart';
import 'package:leaptech_plus/core/routing/app_router.dart';
import 'package:leaptech_plus/core/services/shared_pref_service.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/core/themes/app_colors.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize screenutil
  ScreenUtil.ensureScreenSize();
  //shared pref init
  SharedPreferencesService().init();
//supabase init
  await Supabase.initialize(
    url: 'https://tsbtcbvhgfuxtgafzroa.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRzYnRjYnZoZ2Z1eHRnYWZ6cm9hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMyODA0MDUsImV4cCI6MjA3ODg1NjQwNX0.0hsozGWid4wJro0VXjiIBTIzXjFAs_OYII4fsmEoyBs',
  );
  await Hive.initFlutter();

  // Register adapter
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('userBox');
  // init getIt
  setupGetIt();

  runApp(const LeapTechPlusAPP());
}

class LeapTechPlusAPP extends StatelessWidget {
  const LeapTechPlusAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: ToastificationWrapper(
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          theme: ThemeData(
            drawerTheme: DrawerThemeData(
              backgroundColor: AppColors.white,
            ),
            appBarTheme: AppBarTheme(
              elevation: 0,
              surfaceTintColor: Colors.grey.shade100,
              backgroundColor: Colors.grey.shade100,
            ),
            scaffoldBackgroundColor: Colors.grey.shade300,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.grey.shade100,
            ),
          ),
        ),
      ),
    );
  }
}
