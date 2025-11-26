import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:leaptech_plus/core/errors/failure.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:leaptech_plus/features/members/data/repo/members_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MembersRepoImpl implements MembersRepo {
  final SupabaseService _supabaseService;

  MembersRepoImpl(this._supabaseService);

  @override
  Future<Either<Failure, List<UserModel>>> getAllMembers() async {
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
