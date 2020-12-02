import 'package:ReferralAppNew/screens/referral_app.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Referral App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.black,
        fontFamily: 'Quicksand',
      ),
      home: ReferralApp(),
    );
  }
}
