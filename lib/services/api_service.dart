import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://appquanta-server.onrender.com/api/v1';

  // Get JWT token from Supabase Auth
  Future<String?> _getToken() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session?.accessToken;
  }

  // Cache JWT token locally
  Future<void> _cacheToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    await prefs.setInt(
      'token_timestamp',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Get cached token if still valid (less than 30 minutes old)
  Future<String?> _getCachedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final timestamp = prefs.getInt('token_timestamp');

    if (token != null && timestamp != null) {
      final tokenAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      // Token valid for 30 minutes
      if (tokenAge < 30 * 60 * 1000) {
        return token;
      }
    }
    return null;
  }

  // Get headers with authorization
  Future<Map<String, String>> _getHeaders() async {
    String? token = await _getCachedToken();
    if (token == null) {
      token = await _getToken();
      if (token != null) {
        await _cacheToken(token);
      }
    }

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET /apps - Get user apps
  Future<List<Map<String, dynamic>>> getUserApps() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/apps'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      throw Exception('Failed to load apps: ${response.statusCode}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST /apps/create - Create new app
  Future<Map<String, dynamic>> createApp({
    required String name,
    String? description,
    required String status,
    String? icon,
    String? color,
    List<String>? screens,
    String? type,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = json.encode({
        'name': name,
        'description': description,
        'status': status,
        if (icon != null) 'icon': icon,
        if (color != null) 'color': color,
        if (screens != null) 'screens': screens,
        if (type != null) 'type': type,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/apps/create'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      throw Exception(
        'Failed to create app: ${response.statusCode} - ${response.body}',
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT /apps/{id} - Update app
  Future<Map<String, dynamic>> updateApp({
    required String appId,
    String? name,
    String? description,
    String? status,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = json.encode({
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (status != null) 'status': status,
      });

      final response = await http.put(
        Uri.parse('$baseUrl/apps/$appId'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      throw Exception(
        'Failed to update app: ${response.statusCode} - ${response.body}',
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE /apps/{id} - Delete app
  Future<void> deleteApp(String appId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/apps/$appId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to delete app: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // GET /apps/{id}/preview - Get app preview URL
  Future<String> getPreviewUrl(String appId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/apps/$appId/preview'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Return the URL that serves the HTML preview
        return '$baseUrl/apps/$appId/preview';
      }
      throw Exception('Failed to get preview: ${response.statusCode}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST /apps/{id}/generate-apk - Generate APK
  Future<Map<String, dynamic>> generateApk(String appId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/apps/$appId/generate-apk'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      throw Exception('Failed to generate APK: ${response.statusCode}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // GET /apps/{id}/apk-status - Get APK generation status
  Future<Map<String, dynamic>> getApkStatus(String appId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/apps/$appId/apk-status'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      throw Exception('Failed to get APK status: ${response.statusCode}');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
