import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfigService {
  static final AppConfigService _instance = AppConfigService._internal();
  factory AppConfigService() => _instance;
  AppConfigService._internal();

  Map<String, dynamic> _config = {};

  Future<void> load() async {
    final jsonString = await rootBundle.loadString('assets/config.json');
    _config = json.decode(jsonString);
  }

  dynamic get(String key) => _config[key];

  Map<String, dynamic> get all => _config;
}
