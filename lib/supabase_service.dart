import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  // Base URL do servidor Python
  final String _baseUrl = 'https://appquanta-server.onrender.com';

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
        emailRedirectTo: null,
        captchaToken: null,
      );

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

      await _client.storage
          .from('avatars')
          .uploadBinary(
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

  // Get user's apps - usando servidor Python
  Future<List<Map<String, dynamic>>> getUserApps(String userId) async {
    try {
      // Refresh session to ensure token is valid
      try {
        await _client.auth.refreshSession();
      } catch (e) {
        print('Failed to refresh session: $e');
      }

      final token = _client.auth.currentSession?.accessToken;
      if (token == null) throw Exception('User not authenticated');

      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/apps'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }

      return [];
    } catch (e) {
      print('Failed to get user apps: $e');
      return [];
    }
  }

  // Create new app - usando servidor Python
  Future<Map<String, dynamic>> createApp({
    required String userId,
    required String name,
    required String description,
    required String icon,
    required String color,
    required List<String> screens,
  }) async {
    try {
      // Refresh session to ensure token is valid
      try {
        await _client.auth.refreshSession();
      } catch (e) {
        print('Failed to refresh session: $e');
      }

      final token = _client.auth.currentSession?.accessToken;
      if (token == null) throw Exception('User not authenticated');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/v1/apps/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'status': 'active', // Ajustado para o modelo do servidor
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data'];
        }
      }

      throw Exception('Failed to create app: ${response.body}');
    } catch (e) {
      throw Exception('Failed to create app: $e');
    }
  }

  // Upload APK to storage - usando servidor Python
  Future<String?> uploadApk(
    String userId,
    String appId,
    String fileName,
    List<int> fileBytes,
  ) async {
    try {
      final token = _client.auth.currentSession?.accessToken;
      if (token == null) throw Exception('User not authenticated');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/v1/apps/$appId/upload-apk'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data']['apk_url'];
        }
      }

      throw Exception('Failed to upload APK: ${response.body}');
    } catch (e) {
      throw Exception('Failed to upload APK: $e');
    }
  }

  // Delete app - usando servidor Python
  Future<void> deleteApp(String appId) async {
    try {
      final token = _client.auth.currentSession?.accessToken;
      if (token == null) throw Exception('User not authenticated');

      final response = await http.delete(
        Uri.parse('$_baseUrl/api/v1/apps/$appId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        if (!data['success']) {
          throw Exception('Failed to delete app: ${data['message']}');
        }
      }
    } catch (e) {
      throw Exception('Failed to delete app: $e');
    }
  }
}
