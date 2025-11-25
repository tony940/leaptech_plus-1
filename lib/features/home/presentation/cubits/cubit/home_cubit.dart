import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaptech_plus/features/home/data/models/event_model.dart';
import 'package:leaptech_plus/features/home/data/models/invited_employee_model.dart';
import 'package:leaptech_plus/features/home/data/models/quote_model.dart';
import 'package:leaptech_plus/features/home/data/repo/home_repo_impl.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeRepo) : super(HomeInitial());
  final HomeRepoImpl _homeRepo;

  // Quote of the day
  Future<void> getQuoteOfTheDay() async {
    emit(HomeQuoteLoading());
    var response = await _homeRepo.getQuoteOfTheDay();
    response.fold(
      (failure) => emit(HomeQuoteFailure(failure.errorMessage)),
      (quote) => emit(HomeQuoteSuccess(quote)),
    );
  }

  // Create event
  Future<void> createEvent({required EventModel event}) async {
    emit(HomeEventLoading());
    var response = await _homeRepo.createEvent(event: event);
    response.fold(
      (failure) => emit(HomeEventFailure(failure.errorMessage)),
      (_) => emit(HomeEventCreated()),
    );
  }

  // Get all events
  Future<void> getAllEvents() async {
    emit(HomeEventLoading());
    var response = await _homeRepo.getAllEvents();
    response.fold(
      (failure) => emit(HomeEventFailure(failure.errorMessage)),
      (events) => emit(HomeEventSuccess(events)),
    );
  }

  // Get employees invited to an event
  Future<void> getEventInvitedEmployees({required int eventId}) async {
    emit(HomeEventLoading());
    var response = await _homeRepo.getEventInvitedEmployees(eventId: eventId);
    response.fold(
      (failure) => emit(HomeEventFailure(failure.errorMessage)),
      (employees) {
        final invitedEmployees = employees
            .map((e) => InvitedEmployeeModel.fromMap(e))
            .toList();
        emit(HomeEventInvitedEmployeesSuccess(invitedEmployees));
      },
    );
  }

  // Delete event
  Future<void> deleteEvent({required int eventId}) async {
    emit(HomeEventLoading());
    var response = await _homeRepo.deleteEvent(eventId: eventId);
    response.fold(
      (failure) => emit(HomeEventFailure(failure.errorMessage)),
      (_) => emit(HomeEventDeleted()),
    );
  }
}