import 'package:flutter/material.dart';
import 'package:mosip_pre_registration_mobile/core/common/app_drawer.dart';
import 'package:mosip_pre_registration_mobile/core/common/app_footer.dart';
import 'package:mosip_pre_registration_mobile/core/common/app_header.dart';
import 'package:mosip_pre_registration_mobile/core/services/app_config_service.dart';
import 'package:mosip_pre_registration_mobile/features/auth/auth_service.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated = AuthService.instance.isAuthenticated();
    final String appVersion = AppConfigService.instance.getVersion() ?? '1.0.0';

    return Directionality(
      textDirection: TextDirection.ltr, // later from LanguageProvider
      child: Scaffold(
        appBar: AppHeader(
          isAuthenticated: isAuthenticated,
          onLogin: () {
            Navigator.pushNamed(context, '/eng');
          },
          onHome: () {
            Navigator.pushNamed(context, '/eng/dashboard');
          },
          onLogout: () {
            AuthService.instance.logout();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/eng',
              (_) => false,
            );
          },
          onLogoClick: () {
            if (isAuthenticated) {
              Navigator.pushNamed(context, '/eng/dashboard');
            } else {
              Navigator.pushNamed(context, '/eng');
            }
          },
        ),
        drawer: AppDrawer(
          isAuthenticated: isAuthenticated,
          onLogin: () {
            Navigator.pushNamed(context, '/eng');
          },
          onHome: () {
            Navigator.pushNamed(context, '/eng/dashboard');
          },
          onLogout: () {
            AuthService.instance.logout();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/eng',
              (_) => false,
            );
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 68),
                child: child,
              ),
            ),
            AppFooter(appVersion: appVersion),
          ]
        ),
      ),
    );
  }
}
