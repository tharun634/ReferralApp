import 'package:ReferralAppNew/screens/referral_app.dart';
import 'package:flutter/material.dart';

import './backend/signIn.dart';
import 'backend/signIn.dart';
import 'backend/signIn.dart';
import 'backend/signIn.dart';
import 'backend/signIn.dart';
import 'backend/signIn.dart';
import 'backend/signIn.dart';
import 'screens/referral_app.dart';

// Import the firebase_core plugin

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Referral App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.black,
        fontFamily: 'Quicksand',
        scaffoldBackgroundColor: Colors.white,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.redAccent,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: FutureBuilder(
        future: signInWithGoogle(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Future.delayed(Duration.zero).then(
              (_) => showDialog(
                context: context,
                child: AlertDialog(
                  title: Text('An Error Occured!'),
                  actions: [
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ).then((shouldRetry) {
                if (shouldRetry ?? false)
                  Future.delayed(Duration.zero).then((_) => setState((){}));
              }),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return ReferralApp(snapshot.data);
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
