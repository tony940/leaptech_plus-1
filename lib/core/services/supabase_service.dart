import 'dart:io';

import 'package:leaptech_plus/features/home/data/models/event_model.dart';
import 'package:leaptech_plus/features/login/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Getter to access the client
  SupabaseClient get client => _client;

  // ------------------------------------------------------
  // AUTH
  // ------------------------------------------------------
  /// Register user with email & password
  Future<void> registerEmployee({required UserModel user}) async {
    String? userId;

    // 1. Create user in Supabase Auth
    final response = await _client.auth.signUp(
      email: user.email,
      password: user.password,
    );

    if (response.user != null) {
      userId = response.user!.id;
    } else {
      return;
    }

    // 2. If auth user created successfully → insert into employees table
    if (userId != null) {
      await _client.from('employees').insert({
        'id': userId,
        'full_name': user.fullName,
        'email': user.email,
        'password': user.password, // stored because your schema has it
        'phone': user.phone,
        'image_url': user.imageUrl,
        'title': user.title,
        'type': user.type,
        'branch': user.branch,
      });
    } else {
      return;
    }
  }

  Future<void> editEmployee({required UserModel user}) async {
    // Build the map of fields to update (only editable fields)
    final Map<String, dynamic> updateData = {
      if (user.fullName != null) 'full_name': user.fullName,
      if (user.phone != null) 'phone': user.phone,
      if (user.imageUrl != null) 'image_url': user.imageUrl,
      if (user.title != null) 'title': user.title,
      if (user.type != null) 'type': user.type,
      if (user.branch != null) 'branch': user.branch,
    };

    if (updateData.isEmpty) return; // Nothing to update
    // Update the employee record in Supabase
    await _client.from('employees').update(updateData).eq('id', user.id);
  }

  Future<void> deleteEmployee({required String userId}) async {
    // Delete employee from employees table
    await _client.from('employees').delete().eq('id', userId);
    // Delete user from auth table
    // await _client.auth.admin.deleteUser(userId);
  }

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
    // First get the current user ID
    final userId = currentUser?.id;

    if (userId == null) {
      return []; // Return empty list if user is not logged in
    }

    // Get event IDs that the user is invited to
    final invitationResponse = await _client
        .from('event_invitations')
        .select('event_id')
        .eq('employee_id', userId);

    final invitationData = invitationResponse as List<dynamic>;
    final invitedEventIds =
        invitationData.map((e) => e['event_id'] as int).toList();

    // If user has no invitations, return empty list
    if (invitedEventIds.isEmpty) {
      return [];
    }

    // Get events that the user is invited to
    final response = await _client
        .from('events')
        .select('''
      id,
      name,
      about,
      event_time,
      duration,
      location,
      organizer:employees(full_name)
    ''')
        .inFilter('id', invitedEventIds) // Only get events user is invited to
        .order('event_time', ascending: true);

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
    print('toggle like service called');
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

  // ------------------------------------------------------
  // ADD COMMENT
  // ------------------------------------------------------
  Future<void> addComment({
    required String postId,
    required String userId,
    required String commentText,
  }) async {
    print('add comment service called');
    var res = await _client.from('post_comments').insert({
      'post_id': postId,
      'user_id': userId,
      'content': commentText,
    });
  }

  Future<void> addPost({
    required String userId,
    required String? content,
    List<String>? imageUrls,
  }) async {
    // 1. Insert the post
    final postResponse = await _client
        .from('posts')
        .insert({
          'user_id': userId,
          'content': content,
        })
        .select()
        .single();

    final post = Map<String, dynamic>.from(postResponse);
    final postId = post['id'] as String;

    // 2. If there are images, insert them
    if (imageUrls != null && imageUrls.isNotEmpty) {
      final imagesToInsert = imageUrls.map((url) {
        return {
          'post_id': postId,
          'image_url': url,
        };
      }).toList();

      await _client.from('post_images').insert(imagesToInsert);
    }
  }

//Delete post
  Future<void> deletePost({required String postId}) async {
    await _client.from('posts').delete().eq('id', postId);
  }

  Future<String> uploadImage({
    required File file,
    String folder = 'images',
    String bucket = 'images',
  }) async {
    try {
      // Generate a unique file name
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

      // Upload the file
      final response = await _client.storage.from(bucket).upload(
            '$folder/$fileName',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get the public URL
      final publicUrl =
          _client.storage.from(bucket).getPublicUrl('$folder/$fileName');

      return publicUrl;
    } on StorageException catch (e) {
      throw Exception('Failed to upload image: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error uploading image: $e');
    }
  }

  //get all members

  Future<List<Map<String, dynamic>>> getAllMembers() async {
    final response = await _client.from('employees').select();

    return response;
  }

  // Get employees invited to a specific event
  Future<List<Map<String, dynamic>>> getEventInvitedEmployees(
      {required int eventId}) async {
    final response = await _client.from('event_invitations').select('''
      employee:employees(id, full_name, image_url)
    ''').eq('event_id', eventId);

    final data = response as List<dynamic>;

    return data.map((e) {
      return {
        'id': e['employee']['id'],
        'full_name': e['employee']['full_name'],
        'image_url': e['employee']['image_url'],
      };
    }).toList();
  }
}
