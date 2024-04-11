// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/login/login_page.dart';
import 'package:flutter_application_1/src/utils/my_colors.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        primaryColor: MyColors.primaryColor
      ),
      title: 'Delivery app flutter',
      initialRoute: 'login',
      debugShowCheckedModeBanner: false,
      routes: {
        'login':  (BuildContext bc) => LoginPage()
      }
    );
  }
}