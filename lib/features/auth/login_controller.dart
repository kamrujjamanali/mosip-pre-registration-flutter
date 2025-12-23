import 'dart:async';
import 'package:mosip_pre_registration_mobile/core/constants/app_constants.dart';

import '../../core/services/config_service.dart';
import '../../core/services/data_storage_service.dart';

class LoginController {
  final DataStorageService dataService;
  final ConfigService configService;

  LoginController(this.dataService, this.configService);

  Timer? timer;

  void startTimer(
    String minutes,
    String seconds,
    Function(String, String) onTick,
    Function onExpire,
  ) {
    int min = int.parse(minutes);
    int sec = int.parse(seconds);

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (sec == 0) {
        if (min == 0) {
          timer?.cancel();
          onExpire();
          return;
        }
        min--;
        sec = 59;
      } else {
        sec--;
      }
      onTick(min.toString().padLeft(2, '0'), sec.toString().padLeft(2, '0'));
    });
  }

  Future<bool> validateLoginId(String input) async {
    final mode = await configService.getConfigByKey(
      AppConstants.CONFIG_KEYS['mosip_login_mode'] as String,
    ) as String;

    final emailRegex = RegExp(
      await configService.getConfigByKey(AppConstants.CONFIG_KEYS['mosip_regex_email'] as String) as String,
    );
    final phoneRegex = RegExp(
      await configService.getConfigByKey(AppConstants.CONFIG_KEYS['mosip_regex_phone'] as String) as String,
    );

    if (mode == 'email,mobile') {
      return emailRegex.hasMatch(input) || phoneRegex.hasMatch(input);
    }
    if (mode == 'email') return emailRegex.hasMatch(input);
    if (mode == 'mobile') return phoneRegex.hasMatch(input);

    return false;
  }
}
