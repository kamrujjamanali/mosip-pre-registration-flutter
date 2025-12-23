class DocumentTypeModel {
  final String code;
  final String description;
  final String isActive;
  final String langCode;
  final String name;
  final List<DocumentTypeModel>? documentTypes;

  DocumentTypeModel({
    required this.code,
    required this.description,
    required this.isActive,
    required this.langCode,
    required this.name,
    this.documentTypes,
  });

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    var list = json['documentTypes'] as List<dynamic>?;
    List<DocumentTypeModel>? docs;
    if (list != null) {
      docs = list.map((i) => DocumentTypeModel.fromJson(i)).toList();
    }

    return DocumentTypeModel(
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? '',
      langCode: json['langCode'] ?? '',
      name: json['name'] ?? '',
      documentTypes: docs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
      'isActive': isActive,
      'langCode': langCode,
      'name': name,
      if (documentTypes != null)
        'documentTypes': documentTypes!.map((e) => e.toJson()).toList(),
    };
  }
}