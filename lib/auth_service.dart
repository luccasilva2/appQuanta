import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Register with email and password
  Future<AuthResponse> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );

      if (response.user != null) {
        // Save user data to database
        await _supabase.from('users').insert({
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
      final response = await _supabase.auth.signInWithPassword(
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
    await _supabase.auth.signOut();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }

  // Get user data from database
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final response = await _supabase
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
    await _supabase.from('users').update(data).eq('id', uid);
  }
}
