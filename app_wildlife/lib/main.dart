import 'package:app_wildlife/view/bottomNavigationbar.dart';
import 'package:app_wildlife/view/home_page.dart';
import 'package:app_wildlife/view/screen/dashboard.dart';
import 'package:app_wildlife/view/user/form_input.dart';
import 'package:app_wildlife/view/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const DynamicBottomNavBar(),
    );
  }
}
