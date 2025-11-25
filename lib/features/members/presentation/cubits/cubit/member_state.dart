part of 'member_cubit.dart';

@immutable
sealed class MemberState {}

final class MemberInitial extends MemberState {}

final class MemberLoadedSuccessState extends MemberState {
  final List<UserModel> members;

  MemberLoadedSuccessState(this.members);
}

final class MemberLoadedFailureState extends MemberState {
  final String errMessage;

  MemberLoadedFailureState(this.errMessage);
}

final class MemberLoadingState extends MemberState {}
