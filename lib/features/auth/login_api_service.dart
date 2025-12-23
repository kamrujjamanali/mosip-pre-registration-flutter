import 'package:dio/dio.dart';
import '../../core/services/app_config_service.dart';
import '../../core/constants/api_constants.dart';

class LoginApiService {
  final Dio _dio = Dio();

  String get _baseUrl =>
      AppConfigService().get('preregistration.base.url');

  Future<Response> sendOtp({
    required String contact,
    required String lang,
    required String captchaToken,
  }) {
    return _dio.post(
      '$_baseUrl/${ApiConstants.sendOtp}',
      data: {
        'userId': contact,
        'langCode': lang,
        'captchaToken': captchaToken,
      },
    );
  }

  Future<Response> verifyOtp({
    required String contact,
    required String otp,
  }) {
    return _dio.post(
      '$_baseUrl/${ApiConstants.validateOtp}',
      data: {
        'userId': contact,
        'otp': otp,
      },
    );
  }
}
