import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/i18n/app_localizations_delegate.dart';
import 'core/i18n/language_provider.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_page.dart';

class MosipApp extends StatelessWidget {
  const MosipApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      theme: AppTheme.theme,
      title: 'MOSIP Pre-Registration',
      debugShowCheckedModeBanner: false,

      locale: languageProvider.locale, // 🔥 dynamic

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

      // home: const LoginPage(),
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
