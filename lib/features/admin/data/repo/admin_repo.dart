import 'package:dartz/dartz.dart';
import 'package:leaptech_plus/core/errors/failure.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';

abstract class AdminRepo {
  Future<Either<Failure, List<UserModel>>> getAllEmployees();

  Future<Either<Failure, void>> deleteEmployee({required String userId});
  Future<Either<Failure, void>> updateEmployee({
    required UserModel user,
  });
  Future<Either<Failure, void>> registerEmployee({required UserModel user});
}
