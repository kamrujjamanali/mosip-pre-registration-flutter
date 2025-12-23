import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  // Singleton pattern
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;
  ConfigService._internal();

  late SharedPreferences _prefs;

  // Initialize (call this early in main.dart)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Stores the full config JSON (mirroring Angular's setConfig)
  /// In Angular: localStorage.setItem('config', JSON.stringify(configJson.response))
  void setConfig(Map<String, dynamic> configJson) {
    final response = configJson['response'] ?? configJson;
    _prefs.setString('config', jsonEncode(response));
  }

  /// Returns the entire config as a Map (like getConfig() in Angular)
  Map<String, dynamic> getConfig() {
    final raw = _prefs.getString('config');
    if (raw == null || raw.isEmpty) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  /// Get value by key with optional generic type (like getConfigByKey<T>)
  T? getConfigByKey<T>(String key) {
    final config = getConfig();
    final value = config[key];
    if (value is T) {
      return value;
    }
    // Handle type conversion if needed (e.g., string to int)
    if (T == int && value is String) {
      return int.tryParse(value) as T?;
    }
    if (T == double && value is String) {
      return double.tryParse(value) as T?;
    }
    if (T == bool && value is String) {
      return (value.toLowerCase() == 'true') as T?;
    }
    return null;
  }

  /// Optional: Clear config (useful on logout)
  void clearConfig() {
    _prefs.remove('config');
  }
}