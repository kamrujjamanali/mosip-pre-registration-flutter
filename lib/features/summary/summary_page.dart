import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final String? appId;

  const SummaryPage({super.key, this.appId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: Center(child: Text('AppId: $appId')),
    );
  }
}
