import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;

  AppLocalizations(this.locale);

  Future<void> load() async {
    final map = {'en': 'eng', 'hi': 'hin', 'fr': 'fra'};
    final code = map[locale.languageCode] ?? locale.languageCode;
    final jsonString =
        await rootBundle.loadString('assets/i18n/$code.json');
    _localizedStrings = json.decode(jsonString);
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}
