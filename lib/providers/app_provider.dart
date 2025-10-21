import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AppProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _apps = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get apps => _apps;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load user apps
  Future<void> loadApps() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _apps = await _apiService.getUserApps();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new app
  Future<bool> createApp({
    required String name,
    String? description,
    required String status,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newApp = await _apiService.createApp(
        name: name,
        description: description,
        status: status,
      );
      _apps.add(newApp);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update app
  Future<bool> updateApp({
    required String appId,
    String? name,
    String? description,
    String? status,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedApp = await _apiService.updateApp(
        appId: appId,
        name: name,
        description: description,
        status: status,
      );

      final index = _apps.indexWhere((app) => app['id'] == appId);
      if (index != -1) {
        _apps[index] = updatedApp;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete app
  Future<bool> deleteApp(String appId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteApp(appId);
      _apps.removeWhere((app) => app['id'] == appId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
