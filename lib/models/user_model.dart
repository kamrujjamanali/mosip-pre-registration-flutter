import 'response_model.dart';
import 'files_model.dart';
import 'code_value_modal.dart';

class UserModel {
  final String? preRegId;
  final ResponseModel? request;
  final FilesModel? files;
  final List<CodeValueModal>? location;

  UserModel({
    this.preRegId,
    this.request,
    this.files,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      preRegId: json['preRegId'],
      request: json['request'] != null ? ResponseModel.fromJson(json['request']) : null,
      files: json['files'] != null ? FilesModel.fromJson(json['files']) : null,
      location: json['location'] != null
          ? (json['location'] as List<dynamic>)
              .map((i) => CodeValueModal.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (preRegId != null) 'preRegId': preRegId,
      if (request != null) 'request': request!.toJson(),
      if (files != null) 'files': files!.toJson(),
      if (location != null) 'location': location!.map((e) => e.toJson()).toList(),
    };
  }
}