import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/config_service.dart';
import '../../core/services/data_storage_service.dart';
import '../../core/utils/utils.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // UI State
  bool showSpinner = true;
  bool showContactDetails = true;
  bool showOTP = false;
  bool showSendOTP = true;
  bool showVerify = false;
  bool disableVerify = false;
  bool showCaptcha = true;
  bool enableCaptcha = false;
  bool enableSendOtp = false;

  // Data
  String inputContactDetails = '';
  String inputOTP = '';
  String selectedLanguage = '';
  String dir = 'ltr';
  String errorMessage = '';
  String loadingMessage = '';
  String minutes = '';
  String seconds = '';
  String appVersion = '';
  String? captchaToken;
  bool resetCaptcha = false;

  List<Map<String, String>> languageCodeValue = [];
  List<String> languageSelectionArray = [];
  bool showLanguageDropDown = true;

  Map<String, dynamic> LanguageCodelabels = {};
  Map<String, dynamic> Languagelabels = {};
  Map<String, dynamic> validationMessages = {};

  Timer? _timer;
  late SharedPreferences prefs;
  late ConfigService configService;
  late DataStorageService dataService;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    prefs = await SharedPreferences.getInstance();
    configService = ConfigService();
    dataService = DataStorageService();
    authService = AuthService();

    await authService.init();
    await configService.init();

    _timer?.cancel();

    // Check if already authenticated
    if (prefs.getString(AppConstants.FORCE_LOGOUT) != AppConstants.FORCE_LOGOUT_YES &&
        authService.isAuthenticated()) {
      final langCode = prefs.getString('langCode') ?? 'eng';
      Navigator.pushReplacementNamed(context, '/$langCode/dashboard');
      return;
    }

    // Handle forced logout
    if (prefs.getString(AppConstants.FORCE_LOGOUT) == AppConstants.FORCE_LOGOUT_YES) {
      await authService.onLogout();
      await prefs.remove(AppConstants.FORCE_LOGOUT);
    }

    await loadDefaultConfig();
    await loadConfigs();

    if (ModalRoute.of(context)?.settings.name?.contains(prefs.getString('langCode') ?? '') == true) {
      _handleBrowserReload();
    }

    await prefs.setString('dir', dir);
  }

  Future<void> loadDefaultConfig() async {
    try {
      final response = await dataService.getI18NLanguageFiles('default');
      final data = json.decode(response);
      LanguageCodelabels = data['languages'] ?? {};
    } catch (e) {
      debugPrint('Failed to load default language file: $e');
      LanguageCodelabels = {};
    }
  }

  Future<void> loadConfigs() async {
    try {
      final response = await dataService.getConfig();
      configService.setConfig(response);

      appVersion = configService.getConfigByKey<String>('preregistration.ui.version') ?? '';

      _isCaptchaEnabled();
      _loadLanguagesWithConfig();

      final savedLang = prefs.getString('langCode');
      if (savedLang == null && languageSelectionArray.isNotEmpty) {
        await prefs.setString('langCode', languageSelectionArray[0]);
      }

      final currentRoute = ModalRoute.of(context)?.settings.name;
      final currentLang = prefs.getString('langCode');
      if (currentRoute == null || !(currentRoute.contains(currentLang ?? ''))) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/$currentLang');
        }
      }

      selectedLanguage = prefs.getString('langCode') ?? 'eng';
      _setLanguageDirection(selectedLanguage);

      authService.userPreferredLang = selectedLanguage;
      await prefs.setString('userPrefLanguage', selectedLanguage);

      await _loadValidationMessages();

      if (mounted) {
        setState(() => showSpinner = false);
      }
    } catch (e) {
      debugPrint('Failed to load config: $e');
      if (mounted) setState(() => showSpinner = false);
    }
  }

  void _loadLanguagesWithConfig() {
    final mandatory = Utils.getMandatoryLangs(configService);
    final optional = Utils.getOptionalLangs(configService);
    final minLang = Utils.getMinLangs(configService);
    final maxLang = Utils.getMaxLangs(configService);

    languageSelectionArray = [...mandatory, ...optional];
    showLanguageDropDown = maxLang != 1;

    prefs.setString('availableLanguages', json.encode(languageSelectionArray));

    // Prepare dropdown labels
    languageCodeValue.clear();
    for (final lang in languageSelectionArray) {
      final labelData = LanguageCodelabels[lang] ?? {};
      languageCodeValue.add({
        'code': lang,
        'value': labelData['nativeName'] ?? lang,
        'locale': labelData['locale'] ?? lang,
      });
    }

    prefs.setString(AppConstants.LANGUAGE_CODE_VALUES, json.encode(languageCodeValue));
  }

  void _isCaptchaEnabled() {
    final enabled = configService.getConfigByKey<String>('mosip.preregistration.captcha.enable');
    enableCaptcha = enabled == 'true';
    if (!enableCaptcha) enableSendOtp = true;
    if (enableCaptcha) {
      final siteKey = configService.getConfigByKey<String>('mosip.preregistration.captcha.sitekey');
      // You can store siteKey if needed for reCAPTCHA widget
    }
  }

  Future<void> _loadValidationMessages() async {
    try {
      final response = await dataService.getI18NLanguageFiles(selectedLanguage);
      final data = json.decode(response);
      setState(() {
        Languagelabels = data;
        validationMessages = data['login'] ?? {};
      });
    } catch (e) {
      debugPrint('Failed to load validation messages: $e');
    }
  }

  void _setLanguageDirection(String selectedLang) {
    final ltrConfig = configService.getConfigByKey<String>(
            AppConstants.CONFIG_KEYS['mosip_left_to_right_orientation'] as String) ??
        'eng,fra';
    final ltrList = ltrConfig.split(',');
    dir = ltrList.contains(selectedLang) ? 'ltr' : 'rtl';
    prefs.setString('dir', dir);
  }

  void _handleBrowserReload() {
    final otpSentTimeStr = prefs.getString('otp_sent_time');
    final userContact = prefs.getString('user_email_or_phone');

    if (otpSentTimeStr != null && userContact != null) {
      try {
        final otpSentTime = DateTime.parse(
            otpSentTimeStr.endsWith('Z') ? otpSentTimeStr : '$otpSentTimeStr' + 'Z');
        final now = DateTime.now().toUtc();

        final expiryStr = configService.getConfigByKey<String>(
            AppConstants.CONFIG_KEYS['mosip_kernel_otp_expiry_time'] as String);
        final otpExpiry = int.tryParse(expiryStr ?? '120') ?? 120;

        final diff = now.difference(otpSentTime).inSeconds;
        if (diff <= otpExpiry) {
          final remaining = otpExpiry - diff;

          setState(() {
            showOTP = true;
            showSendOTP = false;
            showContactDetails = false;
            enableSendOtp = false;
            inputContactDetails = userContact;
            _contactController.text = userContact;

            minutes = (remaining ~/ 60).toString().padLeft(2, '0');
            seconds = (remaining % 60).toString().padLeft(2, '0');

            _timer?.cancel();
            _timer = Timer.periodic(const Duration(seconds: 1), (_) => timerFn());
          });
        } else {
          prefs.remove('otp_sent_time');
          prefs.remove('user_email_or_phone');
        }
      } catch (e) {
        prefs.remove('otp_sent_time');
        prefs.remove('user_email_or_phone');
      }
    }
  }

  void timerFn() {
    int sec = int.parse(seconds);
    int min = int.parse(minutes);

    if (sec == 0) {
      if (min == 0) {
        _timer?.cancel();
        if (mounted) {
          setState(() {
            showContactDetails = true;
            showSendOTP = true;
            showOTP = false;
            showVerify = false;
            enableSendOtp = !enableCaptcha;
            showCaptcha = enableCaptcha;
          });
        }
        return;
      }
      min--;
      sec = 59;
      if (mounted) setState(() => minutes = min.toString().padLeft(2, '0'));
    } else {
      sec--;
    }
    if (mounted) setState(() => seconds = sec.toString().padLeft(2, '0'));
  }

  void _setTimer() {
    final timeStr = configService.getConfigByKey<String>(
        AppConstants.CONFIG_KEYS['mosip_kernel_otp_expiry_time'] as String);
    final time = int.tryParse(timeStr ?? '120') ?? 120;
    minutes = (time ~/ 60).toString().padLeft(2, '0');
    seconds = (time % 60).toString().padLeft(2, '0');
  }

  void _changeLanguage() {
    _setLanguageDirection(selectedLanguage);
    authService.userPreferredLang = selectedLanguage;
    prefs.setString('userPrefLanguage', selectedLanguage);
    prefs.setString('langCode', selectedLanguage);

    _loadValidationMessages();

    errorMessage = '';
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/$selectedLanguage');
    }
  }

  void _showVerifyBtn() {
    final lengthStr = configService.getConfigByKey<String>(
        AppConstants.CONFIG_KEYS['mosip_kernel_otp_default_length'] as String);
    final otpLength = int.tryParse(lengthStr ?? '6') ?? 6;

    setState(() {
      showVerify = inputOTP.length == otpLength;
      if (showVerify) errorMessage = '';
    });
  }

  void _loginIdValidator() {
    errorMessage = '';

    final modes = configService.getConfigByKey<String>(AppConstants.CONFIG_KEYS['mosip_login_mode'] as String);
    final emailPattern = configService.getConfigByKey<String>(AppConstants.CONFIG_KEYS['mosip_regex_email'] as String) ?? '';
    final phonePattern = configService.getConfigByKey<String>(AppConstants.CONFIG_KEYS['mosip_regex_phone'] as String) ?? '';

    final emailRegex = RegExp(emailPattern);
    final phoneRegex = RegExp(phonePattern);

    bool isValid = false;
    if (modes == 'email,mobile') {
      isValid = emailRegex.hasMatch(inputContactDetails) || phoneRegex.hasMatch(inputContactDetails);
    } else if (modes == 'email') {
      isValid = emailRegex.hasMatch(inputContactDetails);
    } else if (modes == 'mobile') {
      isValid = phoneRegex.hasMatch(inputContactDetails);
    }

    if (!isValid) {
      errorMessage = validationMessages[
              modes == 'email'
                  ? 'invalidEmail'
                  : modes == 'mobile'
                      ? 'invalidMobile'
                      : 'invalidInput'] ??
          'Invalid input';
    }

    if (mounted) setState(() {});
  }

  Future<void> _submit() async {
    _loginIdValidator();
    resetCaptcha = false;

    if ((showSendOTP) && errorMessage.isEmpty && enableSendOtp) {
      setState(() => loadingMessage = validationMessages['loading'] ?? 'Loading...');

      try {
        final response = await dataService.sendOtpWithCaptcha(
          inputContactDetails,
          selectedLanguage,
          captchaToken ?? '',
        );

        setState(() => loadingMessage = '');

        if (response['errors'] == null) {
          final otpTime = response['responsetime'] ?? DateTime.now().toIso8601String();
          await prefs.setString('otp_sent_time', otpTime);
          await prefs.setString('user_email_or_phone', inputContactDetails);

          setState(() {
            inputOTP = '';
            _otpController.clear();
            showOTP = true;
            showSendOTP = false;
            showContactDetails = false;
            showCaptcha = false;
            _setTimer();
            _timer?.cancel();
            _timer = Timer.periodic(const Duration(seconds: 1), (_) => timerFn());
          });
        }
      } catch (e) {
        _timer?.cancel();
        if (enableCaptcha) {
          setState(() {
            resetCaptcha = true;
            captchaToken = null;
            enableSendOtp = false;
          });
        }
        setState(() => loadingMessage = '');
        _showErrorMessage(e, validationMessages['serverUnavailable']);
      }
    } else if (showVerify && errorMessage.isEmpty) {
      setState(() => disableVerify = true);

      try {
        final response = await dataService.verifyOtp(inputContactDetails, inputOTP);

        if (response[AppConstants.NESTED_ERROR] == null) {
          _timer?.cancel();
          await prefs.setBool('loggedIn', true);
          authService.setToken();
          await prefs.setString('loginId', inputContactDetails);

          setState(() => disableVerify = false);

          if (mounted) {
            Navigator.pushReplacementNamed(context, '/$selectedLanguage/dashboard');
          }
        }
      } catch (e) {
        setState(() {
          inputOTP = '';
          _otpController.clear();
          showVerify = false;
          disableVerify = false;
        });
        _showErrorMessage(e, Languagelabels['message']?['login']?['msg3']);
      }
    }
  }

  void _showErrorMessage(dynamic error, String? customMsg) {
    final errorLabels = Languagelabels[AppConstants.ERROR] ?? {};
    final apiErrorCodes = Languagelabels[AppConstants.API_ERROR_CODES] ?? {};

    final title = errorLabels['errorLabel'] ?? 'Error';
    final errorCode = Utils.getErrorCode(error);

    String message = customMsg ?? 'Something went wrong';
    if (apiErrorCodes[errorCode] != null) {
      message = apiErrorCodes[errorCode];
    }

    // showDialog(
    //   context: context,
    //   builder: (_) => CustomDialog(
    //     title: title,
    //     message: message,
    //     buttonText: errorLabels['button_ok'] ?? 'OK',
    //   ),
    // );
  }

  void _getCaptchaToken(String? token) {
    setState(() {
      captchaToken = token;
      enableSendOtp = token != null;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _contactController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showSpinner
          ? const Center(child: CircularProgressIndicator())
          : Directionality(
              textDirection: dir == 'rtl' ? TextDirection.rtl : TextDirection.ltr,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Text(
                            validationMessages['text'] ?? 'Login',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(fontSize: 18, color: Colors.black87),
                              children: [
                                TextSpan(
                                  text: '${validationMessages['sub_text'] ?? 'Book your appointment for'} ',
                                  style: const TextStyle(fontWeight: FontWeight.w300),
                                ),
                                TextSpan(
                                  text: validationMessages['sub_text_UID'] ?? 'Unique Identification',
                                  style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFfe528d)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 323),
                            child: Column(
                              children: [
                                if (showLanguageDropDown)
                                  DropdownButtonFormField<String>(
                                    value: selectedLanguage,
                                    decoration: const InputDecoration(border: OutlineInputBorder()),
                                    items: languageCodeValue
                                        .map((lang) => DropdownMenuItem(
                                              value: lang['code'],
                                              child: Text(lang['value']!),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        selectedLanguage = value;
                                        _changeLanguage();
                                      }
                                    },
                                  ),
                                const SizedBox(height: 20),
                                if (showContactDetails)
                                  TextField(
                                    controller: _contactController,
                                    onChanged: (v) {
                                      inputContactDetails = v.trim();
                                      if (errorMessage.isNotEmpty) setState(() => errorMessage = '');
                                    },
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: validationMessages['label_email_num'] ?? 'Email / Phone',
                                    ),
                                    autofocus: true,
                                  ),
                                if (enableCaptcha && showCaptcha)
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: ElevatedButton(
                                      onPressed: () => _getCaptchaToken('dummy-token'),
                                      child: const Text('Complete reCAPTCHA'),
                                    ),
                                  ),
                                if (errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(errorMessage,
                                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                  ),
                                if (loadingMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(loadingMessage, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                if (showOTP)
                                  TextField(
                                    controller: _otpController,
                                    onChanged: (v) {
                                      inputOTP = v;
                                      _showVerifyBtn();
                                    },
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: validationMessages['label_otp'] ?? 'Enter OTP',
                                    ),
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                  ),
                                const SizedBox(height: 20),
                                if (showSendOTP)
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22a8c9)),
                                      onPressed: (inputContactDetails.isNotEmpty && enableSendOtp) ? _submit : null,
                                      child: Text(validationMessages['action_send'] ?? 'Send OTP'),
                                    ),
                                  ),
                                if (showVerify)
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22a8c9)),
                                      onPressed: disableVerify ? null : _submit,
                                      child: Text(validationMessages['action_verify'] ?? 'Verify'),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                Visibility(
                                  visible: showOTP,
                                  child: Text(
                                    '${validationMessages['otp_valid_label'] ?? 'OTP valid for'} $minutes:$seconds',
                                    style: const TextStyle(color: Color(0xFFfe528d), fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Footer(appVersion: appVersion),
                  ],
                ),
              ),
            ),
    );
  }
}