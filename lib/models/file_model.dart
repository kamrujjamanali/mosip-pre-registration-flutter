class FileModel {
  final String docCatCode;
  final String docTypCode;
  final String docFileName;
  final String docId; // or documentId
  final String? docRefId;

  FileModel({
    required this.docCatCode,
    required this.docTypCode,
    required this.docFileName,
    required this.docId,
    this.docRefId,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      docCatCode: json['docCatCode'] ?? '',
      docTypCode: json['docTypCode'] ?? '',
      docFileName: json['docFileName'] ?? '',
      docId: json['docId'] ?? json['documentId'] ?? '',
      docRefId: json['docRefId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docCatCode': docCatCode,
      'docTypCode': docTypCode,
      'docFileName': docFileName,
      'docId': docId,
      if (docRefId != null) 'docRefId': docRefId,
    };
  }
}