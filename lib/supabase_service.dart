import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Register with email and password
  Future<AuthResponse> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );

      if (response.user != null) {
        // Save user data to database
        await _client.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'display_name': name,
          'created_at': DateTime.now().toIso8601String(),
          'photo_url': null,
        });
      }

      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _client.auth.currentUser != null;
  }

  // Get user data from database
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', uid)
          .single();

      return response;
    } catch (e) {
      return null;
    }
  }

  // Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await _client.from('users').update(data).eq('id', uid);
  }

  // Upload profile image to Supabase Storage
  Future<String?> uploadProfileImage(
    String userId,
    String fileName,
    List<int> fileBytes,
  ) async {
    try {
      final filePath = 'profile_images/$userId/$fileName';

      await _client.storage.from('avatars').uploadBinary(
        filePath,
        Uint8List.fromList(fileBytes),
        fileOptions: const FileOptions(upsert: true),
      );

      final publicUrl = _client.storage.from('avatars').getPublicUrl(filePath);

      // Update user photo URL in database
      await updateUserData(userId, {'photo_url': publicUrl});

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Get user's apps
  Future<List<Map<String, dynamic>>> getUserApps(String userId) async {
    try {
      final response = await _client
          .from('apps')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  // Create new app
  Future<Map<String, dynamic>> createApp({
    required String userId,
    required String name,
    required String description,
    required String icon,
    required String color,
    required List<String> screens,
  }) async {
    try {
      final appData = {
        'user_id': userId,
        'name': name,
        'description': description,
        'icon': icon,
        'color': color,
        'screens': screens,
        'status': 'Em construção',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('apps')
          .insert(appData)
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to create app: $e');
    }
  }

  // Upload APK to storage
  Future<String?> uploadApk(
    String userId,
    String appId,
    String fileName,
    List<int> fileBytes,
  ) async {
    try {
      final filePath = 'apks/$userId/$appId/$fileName';

      await _client.storage.from('apks').uploadBinary(
        filePath,
        Uint8List.fromList(fileBytes),
        fileOptions: const FileOptions(upsert: true),
      );

      final publicUrl = _client.storage.from('apks').getPublicUrl(filePath);

      // Update app with APK URL
      await _client.from('apps').update({
        'apk_url': publicUrl,
        'status': 'Pronto para download',
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', appId);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload APK: $e');
    }
  }

  // Delete app
  Future<void> deleteApp(String appId) async {
    try {
      // Delete APK from storage first
      final app = await _client.from('apps').select('apk_url').eq('id', appId).single();
      if (app['apk_url'] != null) {
        // Extract file path from URL and delete
        final url = app['apk_url'] as String;
        final filePath = url.split('/').last;
        await _client.storage.from('apks').remove([filePath]);
      }

      // Delete app from database
      await _client.from('apps').delete().eq('id', appId);
    } catch (e) {
      throw Exception('Failed to delete app: $e');
    }
  }
}
