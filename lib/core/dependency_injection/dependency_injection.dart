import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:leaptech_plus/core/networking/dio_factroy.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/features/home/data/api/home_api_constants.dart';
import 'package:leaptech_plus/features/home/data/api/home_api_service.dart';
import 'package:leaptech_plus/features/home/data/repo/home_repo_impl.dart';
import 'package:leaptech_plus/features/home/presentation/cubits/cubit/home_cubit.dart';
import 'package:leaptech_plus/features/login/data/repo/login_repo_impl.dart';
import 'package:leaptech_plus/features/login/presentation/cubits/cubit/login_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Services
  getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());

  // Dio instance
  final homeDio = Dio(BaseOptions(baseUrl: HomeApiConstants.baseUrl, headers: {
    'X-Api-Key': 'nDhrXjtdTqMR5R1Mj1szEg==VDssdEjBgCOBSfLu',
  }));

  getIt.registerLazySingleton<Dio>(() => homeDio);

  // API service
  getIt.registerLazySingleton<HomeApiService>(
    () => HomeApiService(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<LoginRepoImpl>(
      () => LoginRepoImpl(getIt<SupabaseService>()));

  getIt.registerLazySingleton<HomeRepoImpl>(
    () => HomeRepoImpl(
      getIt<HomeApiService>(),
      getIt<SupabaseService>(),
    ),
  );

  // Cubits (better to be factories)
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepoImpl>()));
  getIt
      .registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepoImpl>()));
}
