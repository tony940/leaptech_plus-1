import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:leaptech_plus/core/errors/failure.dart';
import 'package:leaptech_plus/core/services/supabase_service.dart';
import 'package:leaptech_plus/features/home/data/api/home_api_service.dart';
import 'package:leaptech_plus/features/home/data/models/event_model.dart';
import 'package:leaptech_plus/features/home/data/models/quote_model.dart';
import 'package:leaptech_plus/features/home/data/repo/home_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeApiService _homeApiService;
  final SupabaseService _supabaseService;
  HomeRepoImpl(this._homeApiService, this._supabaseService);

  @override
  Future<Either<Failure, QuoteModel>> getQuoteOfTheDay() async {
    try {
      var respones = await _homeApiService.getQuoteOfTheDay();
      return Right(respones[0]);
    } on DioException catch (e) {
      return Left(ServerFailure.dioErrorHandler(e));
    } on SocketException {
      return Left(Failure(errorMessage: 'No internet connection.'));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createEvent({required EventModel event}) async {
    try {
      var response = await _supabaseService.createEvent(event: event);
      return Right(null);
    } on PostgrestException catch (e) {
      return Left(SupbaseFailure.postgrestErrorHandler(e));
    } on SocketException {
      return Left(Failure(errorMessage: 'No internet connection.'));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventModel>>> getAllEvents() async {
    try {
      final response = await _supabaseService.getAllEvents();
      final events = response.map((e) => EventModel.fromMap(e)).toList();
      return Right(events);
    } on PostgrestException catch (e) {
      return Left(SupbaseFailure.postgrestErrorHandler(e));
    } on SocketException {
      return Left(Failure(errorMessage: 'No internet connection.'));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent({required int eventId}) async {
    try {
      await _supabaseService.deleteEvent(id: eventId);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(SupbaseFailure.postgrestErrorHandler(e));
    } on SocketException {
      return Left(Failure(errorMessage: 'No internet connection.'));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getEventInvitedEmployees({required int eventId}) async {
    try {
      final response = await _supabaseService.getEventInvitedEmployees(eventId: eventId);
      return Right(response);
    } on PostgrestException catch (e) {
      return Left(SupbaseFailure.postgrestErrorHandler(e));
    } on SocketException {
      return Left(Failure(errorMessage: 'No internet connection.'));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
