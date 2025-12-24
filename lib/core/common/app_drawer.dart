import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isAuthenticated;
  final VoidCallback onLogin;
  final VoidCallback onLogout;
  final VoidCallback onHome;

  const AppDrawer({
    super.key,
    required this.isAuthenticated,
    required this.onLogin,
    required this.onLogout,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0B6A82)),
            child: Text(
              'MOSIP',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),

          _drawerItem(context, 'ABOUT', () {}),
          _drawerItem(context, 'FAQ', () {}),
          _drawerItem(context, 'CONTACT', () {}),

          const Divider(),

          if (!isAuthenticated)
            _drawerItem(context, 'LOGIN', onLogin)
          else ...[
            _drawerItem(context, 'APPLICATIONS', onHome),
            _drawerItem(context, 'LOGOUT', onLogout),
          ],
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, String label, VoidCallback onTap) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
