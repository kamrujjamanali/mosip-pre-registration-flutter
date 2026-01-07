import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mosip_pre_registration_mobile/core/layout/app_scaffold.dart';
import 'package:provider/provider.dart';

import 'core/i18n/app_localizations_delegate.dart';
import 'core/i18n/language_provider.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/theme/app_theme.dart';

class MosipApp extends StatelessWidget {
  const MosipApp({super.key});

  String _initialRouteFromUrlOrLogin() {
    // Supports both:
    // - https://host/#/demographic/new  (HASH)
    // - https://host/demographic/new   (PATH)
    final fragment = Uri.base.fragment; // e.g. "/demographic/new"
    final path = Uri.base.path;         // e.g. "/demographic/new"

    if (fragment.isNotEmpty) {
      return fragment.startsWith('/') ? fragment : '/$fragment';
    }
    if (path.isNotEmpty && path != '/') {
      return path;
    }
    return AppRoutes.login;
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final initialRoute = kIsWeb ? _initialRouteFromUrlOrLogin() : AppRoutes.login;

    return MaterialApp(
      theme: AppTheme.theme,
      title: 'MOSIP Pre-Registration',
      debugShowCheckedModeBanner: false,

      locale: languageProvider.locale,

      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('hi'),
      ],

      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      initialRoute: initialRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
