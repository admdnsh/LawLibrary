import 'package:flutter/material.dart';
import 'package:law_library/models/user.dart';
import 'package:law_library/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Initialize - check if user is already logged in
  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String? username = await _secureStorage.read(key: 'username');
      final String? password = await _secureStorage.read(key: 'password');

      if (username != null && password != null) {
        // Re-authenticate using stored credentials
        await login(username, password, storeCredentials: false);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String username, String password, {bool storeCredentials = true}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _apiService.login(username, password);
      
      if (user != null) {
        _currentUser = user;
        
        if (storeCredentials) {
          // Store credentials securely
          await _secureStorage.write(key: 'username', value: username);
          await _secureStorage.write(key: 'password', value: password);
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid username or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _secureStorage.delete(key: 'username');
      await _secureStorage.delete(key: 'password');
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}