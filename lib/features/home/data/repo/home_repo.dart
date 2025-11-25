import 'package:dartz/dartz.dart';
import 'package:leaptech_plus/core/errors/failure.dart';
import 'package:leaptech_plus/features/home/data/models/event_model.dart';
import 'package:leaptech_plus/features/home/data/models/quote_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, QuoteModel>> getQuoteOfTheDay();
  Future<Either<Failure, List<EventModel>>> getAllEvents();
  Future<Either<Failure, void>> deleteEvent({required int eventId});
  Future<Either<Failure, void>> createEvent({required EventModel event});
  Future<Either<Failure, List<Map<String, dynamic>>>> getEventInvitedEmployees({required int eventId});
}