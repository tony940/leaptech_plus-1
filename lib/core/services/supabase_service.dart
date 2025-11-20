import 'package:leaptech_plus/features/home/data/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // ------------------------------------------------------
  // AUTH
  // ------------------------------------------------------

  /// Login user with email & password + fetch employee row
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    // Step 1: Login
    final authResponse = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // Step 2: Fetch employee row
    final employee = await _client
        .from('employees')
        .select()
        .eq('id', authResponse.user!.id)
        .maybeSingle();

    return employee != null ? Map<String, dynamic>.from(employee) : null;
  }

  /// Logout user
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  /// Check if the user is logged in
  bool get isLoggedIn => _client.auth.currentSession != null;

  /// Get current logged-in user
  User? get currentUser => _client.auth.currentUser;

  // ------------------------------------------------------
  // EVENTS CRUD METHODS
  // ------------------------------------------------------

  /// CREATE event
  Future<Map<String, dynamic>> createEvent({required EventModel event}) {
    return _client.from('events').insert(event.toMap()).select().single();
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    final response = await _client.from('events').select('''
      id,
      name,
      about,
      event_time,
      duration,
      location,
      organizer:employees(full_name)
    ''').order('event_time', ascending: true);

    final data = response as List<dynamic>;
    final now = DateTime.now();

    final upcomingEvents = data.where((e) {
      final eventTime = DateTime.parse(e['event_time']).toLocal();
      final durationMinutes = (e['duration'] as num).toDouble() * 60;
      final eventEndTime =
          eventTime.add(Duration(minutes: durationMinutes.toInt()));
      return eventEndTime.isAfter(now);
    }).toList();

    return upcomingEvents.map((e) {
      return {
        'id': e['id'],
        'name': e['name'],
        'about': e['about'],
        'event_time': e['event_time'], // return as string
        'duration': (e['duration'] as num).toDouble(),
        'location': e['location'],
        'organizerName': e['organizer']?['full_name'] ?? '',
      };
    }).toList();
  }

  /// DELETE event
  Future<void> deleteEvent({
    required int id,
  }) {
    return _client.from('events').delete().eq('id', id);
  }

  // ---------------posts ---------------------

  Future<List<Map<String, dynamic>>> getAllPostsWithRelations() async {
    final response = await _client.from('posts').select('''
        *,
        post_comments(*, user:employees(id, full_name, image_url)),
        post_likes(user:employees(id, full_name, image_url)),
        post_images(image_url),
        user:employees(id, full_name, image_url)
      ''').order('created_at', ascending: false);

    final data = response as List<dynamic>? ?? [];
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  // toggle like on post
  Future<void> toggleLike({
    required String postId,
    required String userId,
  }) async {
    // Check if like exists
    final existingLike = await _client
        .from('post_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId);

    final data = existingLike as List<dynamic>? ?? [];

    if (data.isNotEmpty) {
      // If exists → delete like
      await _client
          .from('post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);
    } else {
      // If not exists → insert like
      await _client.from('post_likes').insert({
        'post_id': postId,
        'user_id': userId,
      });
    }
  }
}
