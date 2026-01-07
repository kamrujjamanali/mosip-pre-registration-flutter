import 'package:flutter/material.dart';
import 'package:mosip_pre_registration_mobile/core/layout/app_scaffold.dart';

import '../../features/auth/login_page.dart';
import '../../features/dashboard/dashboard_page.dart';
import '../../features/demographic/demographic_page.dart';
import '../../features/file_upload/file_upload_page.dart';
import '../../features/booking/booking_page.dart';
import '../../features/summary/summary_page.dart';
import '../../core/pages/about_us_page.dart';
import '../../core/pages/faq_page.dart';
import '../../core/pages/contact_page.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    debugPrint('🧭 NAVIGATE TO → ${settings.name}');

    // Wrap route creation with AppScaffold to include Navbar and Footer
    switch (settings.name) {
      case '/':
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppScaffold(child: LoginScreen()),
        );

      case AppRoutes.dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppScaffold(child: DashboardPage()),
        );

      case AppRoutes.demographicNew:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppScaffold(child: DemographicPage()),
        );

      case AppRoutes.demographicEdit:
        final appId = settings.arguments as String?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AppScaffold(child: DemographicPage(appId: appId)),
        );

      case AppRoutes.fileUpload:
        final appId = settings.arguments as String?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AppScaffold(child: FileUploadPage(appId: appId)),
        );

      case AppRoutes.booking:
        final appId = settings.arguments as String?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AppScaffold(child: BookingPage(appId: appId)),
        );

      case AppRoutes.summary:
        final appId = settings.arguments as String?;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AppScaffold(child: SummaryPage(appId: appId)),
        );

      case AppRoutes.aboutUs:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppScaffold(child: AboutUsPage()),
        );

      case AppRoutes.faq:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppScaffold(child: FaqPage()),
        );

      case AppRoutes.contact:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppScaffold(child: ContactPage()),
        );

      // Fallback for unknown routes
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppScaffold(child: LoginScreen()),  // Fallback to LoginScreen
        );
    }
  }
}
