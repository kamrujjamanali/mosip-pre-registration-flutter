import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  final String appVersion;

  const AppFooter({
    super.key,
    required this.appVersion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/logo-final.png',
              height: 20,
            ),
            const SizedBox(width: 6),
            const Text(
              'Mosip.io',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pre-registration UI version:',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Roboto',
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  appVersion,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
