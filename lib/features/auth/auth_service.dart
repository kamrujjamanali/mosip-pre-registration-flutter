import 'package:flutter/material.dart';
import 'package:mosip_pre_registration_mobile/core/services/data_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static AuthService get instance => _instance;

  final String cookieName = 'Authorization';
  String? _token;
  bool isCaptchaSuccess = false;
  String? userPreferredLang;

  late SharedPreferences _prefs;
  late DataStorageService _dataStorageService;

  // Initialize (call this early in main.dart)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _dataStorageService = DataStorageService();

    // Restore preferred language
    userPreferredLang = _prefs.getString('userPrefLanguage');

    // Restore token if exists
    _token = getCookie();
  }

  String? getUserPreferredLanguage() {
    return userPreferredLang;
  }

  void setToken() {
    _token = getCookie();
  }

  void removeToken() {
    _token = null;
  }

  /// Get cookie value (only works on web)
  String? getCookie() {
    if (!kIsWeb) return null;

    final cookies = html.document.cookie ?? '';
    final RegExp regex = RegExp('(^| )$cookieName=([^;]+)');
    final match = regex.firstMatch(cookies);

    return match?.group(2);
  }

  void setCaptchaAuthenticate(bool isSuccess) {
    isCaptchaSuccess = isSuccess;
  }

  bool isCaptchaAuthenticated() {
    return isCaptchaSuccess;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    final loggedIn = _prefs.getBool('loggedIn') ?? false;
    final hasToken = _token != null && _token!.isNotEmpty;

    return loggedIn && hasToken;
  }

  /// Logout - exact replica of Angular onLogout()
  Future<void> onLogout({bool force = false}) async {
    // Set logged out flags
    await _prefs.setBool('loggedIn', false);
    await _prefs.setString('loggedOut', 'true');

    if (force) {
      await _prefs.setString('FORCE_LOGOUT', 'YES'); // Matches your constant
    }

    removeToken();
    isCaptchaSuccess = false;

    // Clear specific items + full clear (matching Angular)
    await _prefs.remove('config');
    await _prefs.remove('dir');
    await _prefs.clear(); // Clears everything (same as localStorage.clear())

    // Call backend logout if needed
    try {
      await _dataStorageService.onLogout();
    } catch (e) {
      debugPrint('Logout API call failed: $e');
    }

    // Navigate to root - you'll handle this in your UI
    // In Flutter, navigation is usually done in widgets, so we can't router.navigate here directly.
    // Instead, return a signal or use a navigator key.

    // Suggestion: Use a GlobalKey<NavigatorState> in main.dart
    // Then call: navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (route) => false);
  }

  /// Helper: Update preferred language (called from login)
  void updateUserPreferredLanguage(String lang) {
    userPreferredLang = lang;
    _prefs.setString('userPrefLanguage', lang);
  }

  Future<void> logout({bool force = false}) async {
    await onLogout(force: force);
  }
}