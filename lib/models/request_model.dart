import 'package:mosip_pre_registration_mobile/core/constants/app_constants.dart';
import 'package:mosip_pre_registration_mobile/core/utils/utils.dart';

class RequestModel {
  final String version = AppConstants.VERSION;
  final String requesttime = Utils.getCurrentDate();

  final String id;
  final dynamic request;
  final dynamic metadata;

  RequestModel(this.id, this.request, [this.metadata]);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'requesttime': requesttime,
      'request': request,
      if (metadata != null) 'metadata': metadata,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}