import 'package:flutter/material.dart';

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
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());

      case AppRoutes.demographicNew:
        return MaterialPageRoute(
          builder: (_) => const DemographicPage(),
        );

      case AppRoutes.demographicEdit:
        final appId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DemographicPage(appId: appId),
        );

      case AppRoutes.fileUpload:
        final appId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => FileUploadPage(appId: appId),
        );

      case AppRoutes.booking:
        final appId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BookingPage(appId: appId),
        );

      case AppRoutes.summary:
        final appId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SummaryPage(appId: appId),
        );

      case AppRoutes.aboutUs:
        return MaterialPageRoute(builder: (_) => const AboutUsPage());

      case AppRoutes.faq:
        return MaterialPageRoute(builder: (_) => const FaqPage());

      case AppRoutes.contact:
        return MaterialPageRoute(builder: (_) => const ContactPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
    }
  }
}
