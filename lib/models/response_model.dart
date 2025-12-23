import 'demo_identity_model.dart';

class ResponseModel {
  final String preRegistrationId;
  final String createdBy;
  final String createdDateTime;
  final String updatedDateTime;
  final String langCode;
  final DemoIdentityModel demographicDetails;

  ResponseModel({
    required this.preRegistrationId,
    required this.createdBy,
    required this.createdDateTime,
    required this.updatedDateTime,
    required this.langCode,
    required this.demographicDetails,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      preRegistrationId: json['preRegistrationId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdDateTime: json['createdDateTime'] ?? '',
      updatedDateTime: json['updatedDateTime'] ?? '',
      langCode: json['langCode'] ?? '',
      demographicDetails: DemoIdentityModel.fromJson(json['demographicDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preRegistrationId': preRegistrationId,
      'createdBy': createdBy,
      'createdDateTime': createdDateTime,
      'updatedDateTime': updatedDateTime,
      'langCode': langCode,
      'demographicDetails': demographicDetails.toJson(),
    };
  }
}