import 'file_model.dart';

class FilesModel {
  final List<FileModel>? documentsMetaData;

  FilesModel({this.documentsMetaData});

  factory FilesModel.fromJson(Map<String, dynamic> json) {
    var list = json['documentsMetaData'] as List<dynamic>?;
    List<FileModel>? docs;
    if (list != null) {
      docs = list.map((i) => FileModel.fromJson(i)).toList();
    }

    return FilesModel(documentsMetaData: docs);
  }

  Map<String, dynamic> toJson() {
    return {
      if (documentsMetaData != null)
        'documentsMetaData': documentsMetaData!.map((e) => e.toJson()).toList(),
    };
  }
}