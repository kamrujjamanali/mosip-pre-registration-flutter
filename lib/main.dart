import 'package:flutter/material.dart';
import 'package:mosip_pre_registration_mobile/features/auth/auth_service.dart';
import 'package:mosip_pre_registration_mobile/features/dashboard/dashboard_page.dart';
import 'package:provider/provider.dart';

import 'core/i18n/language_provider.dart';
import 'core/services/app_config_service.dart';
import 'core/services/config_service.dart';
import 'core/services/data_storage_service.dart';
import 'core/utils/local_storage.dart';
import 'features/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services
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

class MosipApp extends StatelessWidget {
  const MosipApp({super.key});

  // List of supported language codes — add more as needed
  static const List<String> supportedLanguages = [
    'eng',
    'ara',
    'fra',
    'hin',
    'tam',
    // Add other languages your app supports
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOSIP Pre-Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Optional: set default font
        useMaterial3: true,
      ),
      // Define all named routes
      routes: {
        // Root route fallback
        '/': (context) => const LoginScreen(),

        // Language-specific login routes: /eng, /ara, etc.
        ...Map.fromEntries(
          supportedLanguages.map(
            (lang) => MapEntry('/$lang', (context) => const LoginScreen()),
          ),
        ),

        // Language-specific dashboard routes: /eng/dashboard, /ara/dashboard, etc.
        ...Map.fromEntries(
          supportedLanguages.map(
            (lang) => MapEntry('/$lang/dashboard', (context) => const DashboardPage()),
          ),
        ),
      },

      // Handle dynamic or unknown routes gracefully
      onUnknownRoute: (settings) {
        // Extract language from unknown route if possible
        final uri = Uri.tryParse(settings.name ?? '');
        if (uri != null && uri.pathSegments.isNotEmpty) {
          final lang = uri.pathSegments.first;
          if (supportedLanguages.contains(lang)) {
            if (uri.pathSegments.length == 1) {
              // /eng → Login
              return MaterialPageRoute(
                builder: (_) => const LoginScreen(),
                settings: settings,
              );
            } else if (uri.pathSegments.length == 2 && uri.pathSegments[1] == 'dashboard') {
              // /eng/dashboard → Dashboard
              return MaterialPageRoute(
                builder: (_) => const DashboardPage(),
                settings: settings,
              );
            }
          }
        }

        // Final fallback
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      },

      // Start with English as default
      initialRoute: '/eng',
    );
  }
}