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
      textDirection: TextDirection.ltr, // Later can be updated from LanguageProvider
      child: Scaffold(
        appBar: AppHeader(
          isAuthenticated: isAuthenticated,
          onLogin: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          onHome: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
          onLogout: () {
            AuthService.instance.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
          onLogoClick: () {
            if (isAuthenticated) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
        drawer: AppDrawer(
          isAuthenticated: isAuthenticated,
          onLogin: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          onHome: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
          onLogout: () {
            AuthService.instance.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 68), // Adjust padding as needed
                child: child,
              ),
            ),
            AppFooter(appVersion: appVersion),
          ],
        ),
      ),
    );
  }
}
