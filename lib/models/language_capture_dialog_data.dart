import 'dart:ui';

class LanguageCaptureDialogData {
  final String title;
  final String message;
  final String errorText;
  final int minLanguage;
  final int maxLanguage;
  final List<String> mandatoryLanguages;
  final String userPrefLanguage;
  final List<LanguageItem> languages;
  final String cancelButtonText;
  final String submitButtonText;
  final TextDirection dir;

  LanguageCaptureDialogData({
    required this.title,
    required this.message,
    required this.errorText,
    required this.minLanguage,
    required this.maxLanguage,
    required this.mandatoryLanguages,
    required this.userPrefLanguage,
    required this.languages,
    required this.cancelButtonText,
    required this.submitButtonText,
    required this.dir,
  });
}

class LanguageItem {
  final String code;
  final String value;

  LanguageItem({required this.code, required this.value});
}
