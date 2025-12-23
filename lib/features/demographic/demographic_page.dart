import 'package:flutter/material.dart';

class DemographicPage extends StatelessWidget {
  final String? appId; // nullable for "new" case

  const DemographicPage({super.key, this.appId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appId == null
            ? 'New Application'
            : 'Edit Application $appId'),
      ),
      body: Center(
        child: Text(
          appId == null
              ? 'Creating new demographic'
              : 'Editing demographic for $appId',
        ),
      ),
    );
  }
}
