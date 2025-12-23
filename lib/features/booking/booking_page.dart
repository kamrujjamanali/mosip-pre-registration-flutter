import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  final String appId;

  const BookingPage({super.key, required this.appId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: Center(child: Text('AppId: $appId')),
    );
  }
}
