import 'package:flutter/material.dart';
import '/views/login_screen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 👇 START APP FROM LOGIN SCREEN
      home: LoginScreen(),
      // home: Scaffold(
      //   body: Center(child: Text("App Working")),
      // ),
    );
  }
}