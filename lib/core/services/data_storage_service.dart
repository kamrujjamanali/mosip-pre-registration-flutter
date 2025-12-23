import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mosip_pre_registration_mobile/core/constants/app_constants.dart';
import 'package:mosip_pre_registration_mobile/core/services/app_config_service.dart';
import 'package:mosip_pre_registration_mobile/models/applicant.model.dart';
import 'package:mosip_pre_registration_mobile/models/request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config_service.dart';

class DataStorageService {
  // Singleton
  static final DataStorageService _instance = DataStorageService._internal();
  factory DataStorageService() => _instance;
  DataStorageService._internal();

  late final String baseUrl;
  late final String preRegUrl;
  late final ConfigService configService;
  late final AppConfigService appConfigService;
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    configService = ConfigService();
    appConfigService = AppConfigService();

    // Assume these are loaded from config (like AppConfigService in Angular)
    // You'll set these via configService or environment
    baseUrl = appConfigService.get('BASE_URL');
    preRegUrl = appConfigService.get('PRE_REG_URL');
    print('base url: $baseUrl');
  }

  // Helper to get current langCode
  String get _langCode => _prefs.getString('langCode') ?? 'eng';

  // ------------------- I18N -------------------
  Future<String> getI18NLanguageFiles(String langCode) async {
    final response = await http.get(Uri.parse('/assets/i18n/$langCode.json'));
    if (response.statusCode == 200) return response.body;
    throw Exception('Failed to load language file: $langCode');
  }

  Future<String> getSecondaryLanguageLabels(String langCode) async {
    return getI18NLanguageFiles(langCode);
  }

  // ------------------- Users / Applicants -------------------
Future<List<Applicant>> getUsers(String userId) async {
  final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['applicants']}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> list = data['response']?['applicants'] ?? 
                              data['applicants'] ?? 
                              data['response'] ?? 
                              (data is List ? data : []);

    return list.map((json) => Applicant.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users: ${response.statusCode}');
  }
}

  Future<dynamic> getUser(String preRegId) async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['applicants']}/$preRegId';
    return _get(url);
  }

  Future<dynamic> addUser(Map<String, dynamic> identity) async {
    final request = RequestModel(AppConstants.IDS['newUser'] as String, identity);
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['applicants']}';
    return _post(url, request.toJson());
  }

  Future<dynamic> updateUser(Map<String, dynamic> identity, String preRegId) async {
    final request = RequestModel(AppConstants.IDS['updateUser'] as String, identity);
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['applicants']}/$preRegId';
    return _put(url, request.toJson());
  }

  // ------------------- Master Data -------------------
  Future<dynamic> getGenderDetails() async {
    final url = '$baseUrl$preRegUrl/proxy${AppConstants.APPEND_URL['gender']}';
    return _get(url);
  }

  Future<dynamic> getResidentDetails() async {
    final url = '$baseUrl$preRegUrl/proxy${AppConstants.APPEND_URL['resident']}';
    return _get(url);
  }

  Future<dynamic> getLocationTypeData() async {
    final url = '$baseUrl$preRegUrl/proxy${AppConstants.APPEND_URL['master_data']}locationHierarchyLevels/$_langCode';
    return _get(url);
  }

  Future<dynamic> getNearbyRegistrationCenters(Map<String, dynamic> coords) async {
    final distance = configService.getConfigByKey(AppConstants.CONFIG_KEYS['preregistration_nearby_centers'] as String);
    final url = '$baseUrl$preRegUrl/proxy${AppConstants.APPEND_URL['master_data']}${AppConstants.APPEND_URL['nearby_registration_centers']}'
        '$_langCode/${coords['longitude']}/${coords['latitude']}/$distance';
    return _get(url);
  }

  Future<dynamic> getRegistrationCentersByName(String locType, String text) async {
    final url = '$baseUrl$preRegUrl/proxy${AppConstants.APPEND_URL['master_data']}${AppConstants.APPEND_URL['registration_centers_by_name']}'
        '$_langCode/$locType/$text';
    return _get(url);
  }

  Future<dynamic> getRegistrationCentersByNamePageWise(
    String locType,
    String text,
    int pageNumber,
    int pageSize,
  ) async {
    final encodedText = Uri.encodeComponent(text);
    final url = '$baseUrl$preRegUrl/proxy${AppConstants.APPEND_URL['master_data']}${AppConstants.APPEND_URL['registration_centers_by_name']}'
        'page/$_langCode/$locType/$encodedText?pageNumber=$pageNumber&pageSize=$pageSize&orderBy=desc&sortBy=createdDateTime';
    return _get(url);
  }

  Future<dynamic> getLocationImmediateHierearchy(String lang, String location) async {
    final url = '$baseUrl$preRegUrl/proxy${AppConstants.APPEND_URL['master_data']}${AppConstants.APPEND_URL['location_immediate_children']}'
        '$location/$lang';
    return _get(url);
  }

  Future<dynamic> getWorkingDays(String registrationCenterId, String langCode) async {
    final url = '$baseUrl$preRegUrl/proxy${AppConstants.APPEND_URL['master_data']}workingdays/$registrationCenterId/$langCode';
    return _get(url);
  }

  // ------------------- Booking & Availability -------------------
  Future<dynamic> getAvailabilityData(String registrationCenterId) async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['booking_availability']}$registrationCenterId';
    return _get(url);
  }

  Future<dynamic> makeBooking(RequestModel request) async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['booking_appointment']}';
    return _post(url, request.toJson());
  }

  Future<dynamic> getAppointmentDetails(String preRegId) async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['booking_appointment']}/$preRegId';
    return _get(url);
  }

  Future<dynamic> cancelAppointment(RequestModel data, String preRegId) async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['cancelAppointment']}$preRegId';
    return _put(url, data.toJson());
  }

  // ------------------- Documents -------------------
  Future<dynamic> getUserDocuments(String preRegId) async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['document']}$preRegId';
    return _get(url);
  }

  Future<dynamic> sendFile(Map<String, dynamic> formData, String preRegId) async {
    final uri = Uri.parse('$baseUrl$preRegUrl${AppConstants.APPEND_URL['post_document']}$preRegId');
    final request = http.MultipartRequest('POST', uri);

    formData.forEach((key, value) {
      if (value is http.MultipartFile) {
        request.files.add(value);
      } else {
        request.fields[key] = value.toString();
      }
    });

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    return json.decode(respStr);
  }

  Future<dynamic> deleteFile(String documentId, String preRegId) async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['post_document']}$documentId'
        '?${AppConstants.PARAMS_KEYS['preRegistrationId']}=$preRegId';
    return _delete(url);
  }

  Future<dynamic> copyDocument(String sourceId, String destinationId) async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['post_document']}$destinationId'
        '?catCode=${AppConstants.PARAMS_KEYS['POA']}&sourcePreId=$sourceId';
    return _put(url, {});
  }

  Future<dynamic> updateDocRefId(String fileDocumentId, String preId, String refNumber) async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['updateDocRefId']}$fileDocumentId'
        '?${AppConstants.PARAMS_KEYS['preRegistrationId']}=$preId&${AppConstants.PARAMS_KEYS['docRefId']}=$refNumber';
    return _put(url, {});
  }

  // ------------------- Auth / OTP -------------------
  Future<dynamic> sendOtp(String userId, String langCode) async {
    final req = {'langCode': langCode, 'userId': userId};
    final request = RequestModel(AppConstants.IDS['sendOtp'] as String, req);
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['auth']}${AppConstants.APPEND_URL['send_otp']}/langcode';
    return _post(url, request.toJson());
  }

  Future<dynamic> sendOtpWithCaptcha(String userId, String langCode, String captchaToken) async {
    final req = {'langCode': langCode, 'userId': userId, 'captchaToken': captchaToken};
    final request = RequestModel(AppConstants.IDS['sendOtp'] as String, req);
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['auth']}sendOtpWithCaptcha';
    return _post(url, request.toJson());
  }

  Future<dynamic> verifyOtp(String userId, String otp) async {
    final requestPayload = {'otp': otp, 'userId': userId};
    final request = RequestModel(AppConstants.IDS['validateOtp'] as String, requestPayload);
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['auth']}${AppConstants.APPEND_URL['login']}';
    return _post(url, request.toJson());
  }

  Future<dynamic> onLogout() async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['auth']}${AppConstants.APPEND_URL['logout']}';
    return _post(url, {});
  }

  // ------------------- Config & Misc -------------------
  Future<dynamic> getConfig() async {
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['auth']}${AppConstants.APPEND_URL['config']}';
    return _get(url);
  }

  Future<dynamic> getIdentityJson() async {
    final url = '$baseUrl$preRegUrl/uispec/latest';
    return _get(url);
  }

  Future<dynamic> generateQRCode(String data) async {
    final request = RequestModel(AppConstants.IDS['qrCode'] as String, data);
    final url = '$baseUrl$preRegUrl${AppConstants.APPEND_URL['qr_code']}';
    return _post(url, request.toJson());
  }

  Future<dynamic> sendNotification(Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl$preRegUrl${AppConstants.APPEND_URL['notification']}');
    final request = http.MultipartRequest('POST', uri);
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return json.decode(response.body);
  }

  // Add more methods as needed (e.g., transliteration, dynamic fields, audit log, etc.)

  // ------------------- HTTP Helpers -------------------
  Future<dynamic> _get(String url) async {
    final response = await http.get(Uri.parse(url));
    return _handleResponse(response);
  }

  Future<dynamic> _post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> _put(String url, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> _delete(String url) async {
    final response = await http.delete(Uri.parse(url));
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      try {
        return json.decode(response.body);
      } catch (e) {
        return response.body;
      }
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }
}