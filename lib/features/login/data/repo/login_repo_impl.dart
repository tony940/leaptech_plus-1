import 'package:dartz/dartz.dart';
import 'package:leaptech_plus/core/errors/failure.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:leaptech_plus/features/login/data/repo/login_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';

class LoginRepoImpl implements LoginRepo {
  final SupabaseService _supabaseService;

  LoginRepoImpl(this._supabaseService);

  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Call SupabaseService to login
      final response = await _supabaseService.login(
        email: email,
        password: password,
      );

      // Parse user model
      final user = UserModel.fromJson(response!);
      print(user);
      print(user.imageUrl);

      // Save user in Hive
      try {
        await Hive.box<UserModel>('userBox').put('currentUser', user);
        return Right(user); // Success
      } on HiveError {
        return Left(CacheFailure(errorMessage: 'error on caching user'));
      }
    } on PostgrestException catch (e) {
      final failure = SupbaseFailure.postgrestErrorHandler(e);
      return Left(failure);
    } on AuthException catch (e) {
      final failure = SupbaseFailure.authErrorHandler(e);
      return Left(failure);
    } catch (e) {
      return Left(SupbaseFailure(errorMessage: e.toString()));
    }
  }
}
