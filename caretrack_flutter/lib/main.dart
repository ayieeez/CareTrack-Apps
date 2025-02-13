import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(CareTrackApp());
}

class CareTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareTrack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
