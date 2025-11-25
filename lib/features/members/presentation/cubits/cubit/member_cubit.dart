import 'package:bloc/bloc.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:leaptech_plus/features/members/data/repo/members_repo_impl.dart';
import 'package:meta/meta.dart';

part 'member_state.dart';

class MemberCubit extends Cubit<MemberState> {
  MemberCubit(this._membersRepoImpl) : super(MemberInitial());
  final MembersRepoImpl _membersRepoImpl;

  Future<void> getAllMembers() async {
    emit(MemberLoadingState());
    final response = await _membersRepoImpl.getAllMembers();
    response.fold(
      (failure) {
        emit(MemberLoadedFailureState(failure.errorMessage));
      },
      (users) {
        emit(MemberLoadedSuccessState(users));
      },
    );
  }
}
