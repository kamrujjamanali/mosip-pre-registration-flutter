import 'package:flutter/material.dart';

class FileUploadPage extends StatelessWidget {
  final String? appId;

  const FileUploadPage({super.key, this.appId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Upload')),
      body: Center(child: Text('AppId: $appId')),
    );
  }
}
