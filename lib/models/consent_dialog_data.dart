import 'dart:ui';

class ConsentDialogData {
  final String title;
  final List<ConsentLanguageBlock> data;
  final List<TextDirection> textDirectionArr;
  final String cancelBtn;
  final String userPreferredLangCode;

  final String alertMessageFirst;
  final String alertMessageSecond;
  final String alertMessageThird;

  ConsentDialogData({
    required this.title,
    required this.data,
    required this.textDirectionArr,
    required this.cancelBtn,
    required this.userPreferredLangCode,
    required this.alertMessageFirst,
    required this.alertMessageSecond,
    required this.alertMessageThird,
  });
}

class ConsentLanguageBlock {
  final String langCode;
  final List<String> fileText;
  final ConsentLabels labels;

  ConsentLanguageBlock({
    required this.langCode,
    required this.fileText,
    required this.labels,
  });
}

class ConsentLabels {
  final String title;
  final String subtitle;
  final String acceptButton;
  final String checkCondition;

  ConsentLabels({
    required this.title,
    required this.subtitle,
    required this.acceptButton,
    required this.checkCondition,
  });
}
