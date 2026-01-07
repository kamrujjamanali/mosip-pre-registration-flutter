import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/i18n/language_provider.dart';
import 'core/services/app_config_service.dart';
import 'core/services/config_service.dart';
import 'core/services/data_storage_service.dart';
import 'core/utils/local_storage.dart';
import 'features/auth/auth_service.dart';

import 'app.dart'; // ✅ MosipApp from app.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfigService().load();
  await ConfigService().init();
  await LocalStorageService().init();
  await AuthService().init();
  await DataStorageService().init();

  runApp(
    ChangeNotifierProvider<LanguageProvider>(
      create: (_) => LanguageProvider(),
      child: const MosipApp(),
    ),
  );
}
