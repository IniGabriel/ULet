// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'pages/user_form/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xffFFF6F6),
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.redAccent,
            selectionHandleColor: Colors.redAccent,
            cursorColor: Colors.redAccent,
          )),
      home: const SignIn(),
    );
  }
}
