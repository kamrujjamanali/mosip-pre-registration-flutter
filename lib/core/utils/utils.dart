import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../services/config_service.dart';

class Utils {
  // ---------------------------
  // SAFE JSON STORAGE (SharedPreferences)
  // ---------------------------

  static Future<dynamic> readJSON(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    return value != null ? json.decode(value) : null;
  }

  static Future<void> writeJSON(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(data));
  }

  // ---------------------------
  // DATE FUNCTIONS
  // ---------------------------

  static String getCurrentDate() {
    final now = DateTime.now().toUtc();
    final formatted = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(now);
    return '${formatted}Z';
  }

  static String? getURL(String currentURL, String nextRoute, [int numberOfPop = 2]) {
    if (currentURL.isEmpty) return null;

    final segments = currentURL.split('/');
    for (int i = 0; i < numberOfPop && segments.isNotEmpty; i++) {
      segments.removeLast();
    }
    segments.add(nextRoute);
    return segments.join('/');
  }

  // ---------------------------
  // TIME FORMATTING
  // ---------------------------

  static String formatTime(String timeSlotFrom) {
    final parts = timeSlotFrom.split(':');
    if (parts.length < 2) return timeSlotFrom;

    int hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$hour:$minute $period';
  }

  // ---------------------------
  // LANGUAGE CONFIG HELPERS
  // ---------------------------

  static List<String> getMandatoryLangs(ConfigService configService) {
    final langs = configService.getConfigByKey<String>(
            AppConstants.CONFIG_KEYS['mosip_mandatory_languages'] as String) ??
        '';
    return langs.split(',').where((item) => item.trim().isNotEmpty).toList();
  }

  static List<String> getOptionalLangs(ConfigService configService) {
    final langs = configService.getConfigByKey<String>(
            AppConstants.CONFIG_KEYS['mosip_optional_languages'] as String) ??
        '';
    return langs.split(',').where((item) => item.trim().isNotEmpty).toList();
  }

  static int getMinLangs(ConfigService configService) {
    final count = configService.getConfigByKey<String>(
        AppConstants.CONFIG_KEYS['mosip_min_languages_count'] as String);
    return int.tryParse(count ?? '') ?? 0;
  }

  static int getMaxLangs(ConfigService configService) {
    final count = configService.getConfigByKey<String>(
        AppConstants.CONFIG_KEYS['mosip_max_languages_count'] as String);
    return int.tryParse(count ?? '') ?? 0;
  }

  static List<String> reorderLangsForUserPreferredLang(
    List<String> dataCaptureLanguages,
    String userPreferredLangCode,
  ) {
    if (dataCaptureLanguages.contains(userPreferredLangCode)) {
      return [
        userPreferredLangCode,
        ...dataCaptureLanguages.where((lang) => lang != userPreferredLangCode),
      ];
    }
    return List.from(dataCaptureLanguages);
  }

  static Future<List<String>> getLanguageLabels(
    String dataCaptureLanguagesKey,
    String languageCodeValuesKey,
  ) async {
    final availableLangs = await Utils.readJSON(dataCaptureLanguagesKey) ?? [];
    final codeValues = await Utils.readJSON(languageCodeValuesKey) ?? [];

    final List<String> labels = [];

    if (availableLangs is List) {
      for (final langCode in availableLangs) {
        final match = codeValues.firstWhere(
          (el) => el['code'] == langCode,
          orElse: () => null,
        );
        if (match != null) labels.add(match['value']);
      }
    } else if (availableLangs is String) {
      final match = codeValues.firstWhere(
        (el) => el['code'] == availableLangs,
        orElse: () => null,
      );
      if (match != null) labels.add(match['value']);
    }

    return labels;
  }

  // ---------------------------
  // BOOKING DATE FORMATTING (with locale support)
  // ---------------------------

  static Future<String> getBookingDateTime(
    String appointmentDate,
    String timeSlotFrom,
    String language,
    List<String> ltrLangs,
  ) async {
    // Extract locale from language code
    String localeId = language.substring(0, 2);

    // Try to get full locale from stored language values
    final codeValues = await Utils.readJSON(AppConstants.LANGUAGE_CODE_VALUES) ?? [];
    for (final element in codeValues) {
      if (language == element['code'] && element['locale'] != null) {
        localeId = element['locale'].split('_').first;
        break;
      }
    }

    // Initialize locale if not already done
    await initializeDateFormatting(localeId, null);

    final formatter = DateFormat.yMMM(localeId);
    final dateParts = appointmentDate.split('-'); // YYYY-MM-DD
    final tempDate = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
    );

    String formattedMonth = formatter.format(tempDate); // e.g., "Jan", "يناير"

    final day = dateParts[2];
    final year = dateParts[0];

    final dateStr = ltrLangs.contains(language)
        ? '$day $formattedMonth $year'
        : '$year $formattedMonth $day';

    return dateStr;
  }

  // ---------------------------
  // ERROR HANDLING
  // ---------------------------

  static String getErrorCode(Map<String, dynamic> error) {
    return error[AppConstants.ERROR]?[AppConstants.NESTED_ERROR]?[0]
            ?[AppConstants.ERROR_CODE] ??
        '';
  }

  static String getErrorMessage(Map<String, dynamic> error) {
    return error[AppConstants.ERROR]?[AppConstants.NESTED_ERROR]?[0]?['message'] ??
        '';
  }

  static bool authenticationFailed(Map<String, dynamic> error) {
    final errorCode = getErrorCode(error);
    return [
      AppConstants.ERROR_CODES['tokenExpired'],
      AppConstants.ERROR_CODES['invalidateToken'],
      AppConstants.ERROR_CODES['authenticationFailed'],
    ].contains(errorCode);
  }

  static String createErrorMessage(
    Map<String, dynamic> error,
    Map<String, dynamic> errorLabels,
    Map<String, dynamic> apiErrorCodes,
    Map<String, dynamic> config,
  ) {
    String message = errorLabels['error'] ?? 'Error occurred';

    if (authenticationFailed(error)) {
      return errorLabels['sessionInvalidLogout'] ?? 'Session expired. Please login again.';
    }

    final errorCode = getErrorCode(error);
    if (apiErrorCodes[errorCode] != null) {
      message = apiErrorCodes[errorCode];
    }

    final email = config[AppConstants.CONFIG_KEYS['preregistration_contact_email']] ?? '';
    final phone = config[AppConstants.CONFIG_KEYS['preregistration_contact_phone']] ?? '';

    final contactInfo = errorLabels['contactInformation'];
    if (contactInfo != null && contactInfo is List && contactInfo.length >= 3) {
      message += ' ${contactInfo[0]}$email${contactInfo[1]}$phone';
      if (errorCode.isNotEmpty) {
        message += '${contactInfo[2]}$errorCode';
      }
    }

    return message;
  }

  // ---------------------------
  // POPUP ATTRIBUTES FOR LANGUAGE SELECTION
  // ---------------------------

  static Future<Map<String, dynamic>> getLangSelectionPopupAttributes(
    String textDir,
    Map<String, dynamic> dataCaptureLabels,
    List<String> mandatoryLanguages,
    int minLanguage,
    int maxLanguage,
    String userPrefLanguage,
  ) async {
    final codeValues = await Utils.readJSON(AppConstants.LANGUAGE_CODE_VALUES) ?? [];

    final mandatoryLangNames = mandatoryLanguages
        .map((code) => codeValues.firstWhere(
              (e) => e['code'] == code,
              orElse: () => {'value': ''},
            )['value'] as String)
        .where((name) => name.isNotEmpty)
        .join(', ');

    String popupMainMessage;
    final msg = dataCaptureLabels['message'];
    if (minLanguage == maxLanguage) {
      popupMainMessage = '${msg[0]} $minLanguage ${msg[3]}';
    } else {
      popupMainMessage =
          '${msg[1]} $minLanguage ${msg[2]} $maxLanguage ${msg[3]}';
    }

    if (mandatoryLanguages.isNotEmpty) {
      popupMainMessage += ' $mandatoryLangNames ${msg[4]}';
    }
    popupMainMessage += ' ${msg[5]}';

    return {
      'case': 'LANGUAGE_CAPTURE',
      'title': dataCaptureLabels['title'],
      'dir': textDir,
      'languages': codeValues,
      'mandatoryLanguages': mandatoryLanguages,
      'userPrefLanguage': userPrefLanguage,
      'minLanguage': minLanguage,
      'maxLanguage': maxLanguage,
      'message': popupMainMessage,
      'cancelButtonText': dataCaptureLabels['cancel_btn'],
      'submitButtonText': dataCaptureLabels['submit_btn'],
      'errorText':
          '${dataCaptureLabels['error_text'][0]} $maxLanguage ${dataCaptureLabels['error_text'][1]}',
    };
  }

  // ---------------------------
  // EXTRACT LANGUAGES FROM USER REQUEST
  // ---------------------------

  static List<String> getApplicationLangs(Map<String, dynamic> userRequest) {
    final result = <String>{}; // Use Set to avoid duplicates

    final demographicData = userRequest['demographicDetails']?['identity'];
    if (demographicData != null) {
      demographicData.values.forEach((arr) {
        if (arr is List) {
          for (final item in arr) {
            if (item['language'] != null) {
              result.add(item['language']);
            }
          }
        }
      });
    } else if (userRequest['langCode'] != null) {
      result.add(userRequest['langCode']);
    }

    return result.toList();
  }
}