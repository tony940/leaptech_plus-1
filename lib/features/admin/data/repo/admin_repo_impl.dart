import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:leaptech_plus/core/errors/failure.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/features/admin/data/repo/admin_repo.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminRepoImpl implements AdminRepo {
  final SupabaseService _supabaseService;

  AdminRepoImpl({required SupabaseService supabaseService})
      : _supabaseService = supabaseService;
  @override
  Future<Either<Failure, void>> deleteEmployee({required String userId}) async {
    try {
      await _supabaseService.deleteEmployee(userId: userId);
      return Right(null);
    } on PostgrestException catch (e) {
      return Left(SupbaseFailure.postgrestErrorHandler(e));
    } on AuthException catch (e) {
      return Left(SupbaseFailure.authErrorHandler(e));
    } on SocketException catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerEmployee(
      {required UserModel user}) async {
    try {
      await _supabaseService.registerEmployee(user: user);
      return Right(null);
    } on PostgrestException catch (e) {
      return Left(SupbaseFailure.postgrestErrorHandler(e));
    } on AuthException catch (e) {
      return Left(SupbaseFailure.authErrorHandler(e));
    } on SocketException catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmployee(
      {required UserModel user}) async {
    try {
      await _supabaseService.editEmployee(user: user);
      return Right(null);
    } on PostgrestException catch (e) {
      return Left(SupbaseFailure.postgrestErrorHandler(e));
    } on AuthException catch (e) {
      return Left(SupbaseFailure.authErrorHandler(e));
    } on SocketException catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getAllEmployees() async {
    try {
      var response = await _supabaseService.getAllMembers();
      List<UserModel> users =
          response.map((user) => UserModel.fromJson(user)).toList();
      return Right(users);
    } on PostgrestException catch (e) {
      return Left(SupbaseFailure.postgrestErrorHandler(e));
    } on SocketException {
      return Left(Failure(errorMessage: 'No internet connection'));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
