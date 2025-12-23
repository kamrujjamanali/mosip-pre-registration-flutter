class CodeValueModal {
  final String valueCode;
  final String valueName;
  final String languageCode;

  CodeValueModal({
    required this.valueCode,
    required this.valueName,
    required this.languageCode,
  });

  factory CodeValueModal.fromJson(Map<String, dynamic> json) {
    return CodeValueModal(
      valueCode: json['valueCode'] ?? '',
      valueName: json['valueName'] ?? '',
      languageCode: json['languageCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valueCode': valueCode,
      'valueName': valueName,
      'languageCode': languageCode,
    };
  }
}