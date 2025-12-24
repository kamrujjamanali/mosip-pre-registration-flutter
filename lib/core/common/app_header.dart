import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool isAuthenticated;
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final VoidCallback onHome;
  final VoidCallback onLogoClick;

  const AppHeader({
    super.key,
    required this.isAuthenticated,
    required this.onLogin,
    required this.onLogout,
    required this.onHome,
    required this.onLogoClick,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 670;

    return AppBar(
      backgroundColor: const Color(0xFF0B6A82),
      elevation: 1,
      automaticallyImplyLeading: isMobile,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 12),

          /// LOGO
          GestureDetector(
            onTap: onLogoClick,
            child: Image.asset(
              'images/logo-final.png',
              height: 40,
            ),
          ),

          /// Desktop links
          if (!isMobile) ...[
            const SizedBox(width: 25),
            _navItem(context, 'ABOUT', () {}),
            _navItem(context, 'FAQ', () {}),
            _navItem(context, 'CONTACT', () {}),
          ],

          const Spacer(),

          /// Right actions
          if (!isAuthenticated)
            _navItem(context, 'LOGIN', onLogin)
          else ...[
            _iconNavItem(
              context,
              Icons.folder_open,
              'APPLICATIONS',
              onHome,
            ),
            _iconNavItem(
              context,
              Icons.power_settings_new,
              'LOGOUT',
              onLogout,
            ),
          ],

          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _iconNavItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
