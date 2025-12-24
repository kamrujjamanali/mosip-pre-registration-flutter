import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/i18n/language_provider.dart';
import 'core/layout/app_scaffold.dart';
import 'core/services/app_config_service.dart';
import 'core/services/config_service.dart';
import 'core/services/data_storage_service.dart';
import 'core/utils/local_storage.dart';

import 'features/auth/auth_service.dart';
import 'features/auth/login_page.dart';
import 'features/dashboard/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all services (Angular-style app init)
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

  // Supported languages (same concept as Angular i18n routes)
  static const List<String> supportedLanguages = [
    'eng',
    'ara',
    'fra',
    'hin',
    'tam',
  ];

  /// Wrapper → replaces <mat-sidenav-container>
  Widget _withScaffold(Widget page) {
    return AppScaffold(child: page);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOSIP Pre-Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),

      /// Default entry
      initialRoute: '/eng',

      /// Named routes (Angular Router equivalent)
      routes: {
        // Root fallback
        '/': (_) => _withScaffold(const LoginScreen()),

        // Language-based login routes → /eng, /ara, etc.
        ...Map.fromEntries(
          supportedLanguages.map(
            (lang) => MapEntry(
              '/$lang',
              (_) => _withScaffold(const LoginScreen()),
            ),
          ),
        ),

        // Language-based dashboard routes → /eng/dashboard
        ...Map.fromEntries(
          supportedLanguages.map(
            (lang) => MapEntry(
              '/$lang/dashboard',
              (_) => _withScaffold(const DashboardPage()),
            ),
          ),
        ),
      },

      /// Graceful fallback (same idea as Angular wildcard route)
      onUnknownRoute: (settings) {
        final uri = Uri.tryParse(settings.name ?? '');

        if (uri != null && uri.pathSegments.isNotEmpty) {
          final lang = uri.pathSegments.first;

          if (supportedLanguages.contains(lang)) {
            // /eng
            if (uri.pathSegments.length == 1) {
              return MaterialPageRoute(
                builder: (_) => _withScaffold(const LoginScreen()),
                settings: settings,
              );
            }

            // /eng/dashboard
            if (uri.pathSegments.length == 2 &&
                uri.pathSegments[1] == 'dashboard') {
              return MaterialPageRoute(
                builder: (_) => _withScaffold(const DashboardPage()),
                settings: settings,
              );
            }
          }
        }

        // Final safety net
        return MaterialPageRoute(
          builder: (_) => _withScaffold(const LoginScreen()),
        );
      },
    );
  }
}
