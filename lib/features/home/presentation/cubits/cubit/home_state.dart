// home_state.dart
part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

// Quote states
final class HomeInitial extends HomeState {}

final class HomeQuoteLoading extends HomeState {}

final class HomeQuoteFailure extends HomeState {
  final String errorMessage;
  HomeQuoteFailure(this.errorMessage);
}

final class HomeQuoteSuccess extends HomeState {
  final QuoteModel quote;
  HomeQuoteSuccess(this.quote);
}

// Event states
final class HomeEventLoading extends HomeState {}

final class HomeEventFailure extends HomeState {
  final String errorMessage;
  HomeEventFailure(this.errorMessage);
}

final class HomeEventCreated extends HomeState {}

final class HomeEventDeleted extends HomeState {}

final class HomeEventSuccess extends HomeState {
  final List<EventModel> events;
  HomeEventSuccess(this.events);
}

final class HomeEventInvitedEmployeesSuccess extends HomeState {
  final List<InvitedEmployeeModel> invitedEmployees;
  HomeEventInvitedEmployeesSuccess(this.invitedEmployees);
}