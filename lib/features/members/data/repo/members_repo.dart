import 'package:dartz/dartz.dart';
import 'package:leaptech_plus/core/errors/failure.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:leaptech_plus/features/members/data/models/members_model.dart';

abstract class MembersRepo {
  Future<Either<Failure, List<UserModel>>> getAllMembers();
}
