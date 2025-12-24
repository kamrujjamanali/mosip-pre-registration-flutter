import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance =
      LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  static LocalStorageService get instance => _instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ---------------- BASIC ----------------

  String? getString(String key) => _prefs?.getString(key);

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  bool? getBool(String key) => _prefs?.getBool(key);

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  // ---------------- JSON ----------------

  Future<void> setJson(String key, dynamic value) async {
    await _prefs?.setString(key, jsonEncode(value));
  }

  dynamic getJson(String key) {
    final data = _prefs?.getString(key);
    return data == null ? null : jsonDecode(data);
  }

  // ---------------- REMOVE ----------------

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }
}
