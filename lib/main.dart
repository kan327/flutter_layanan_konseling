import 'package:flutter/material.dart';
import 'package:layanan_konseling/screen/homepage.dart';
import 'package:layanan_konseling/screen/login.dart';
import 'package:layanan_konseling/screen/splash_screen.dart';
import 'package:layanan_konseling/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: const TextTheme(
            bodyText1: TextStyle(color: blackFont), // Warna teks default
          ),
          useMaterial3: true,
        ),
        home: CheckAuth(),
      );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  late SharedPreferences sharedPreferences;
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    sharedPreferences = await SharedPreferences
        .getInstance(); 
    var token = sharedPreferences
        .getString('token');
    if (token != null) {
      if (mounted) {
        setState(() {
          isAuth = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      // perbandingan sederhana dengan isAuth yang sudah dikondisikan tadi diatas
      child = Homepage();
    } else {
      child = SplashScreen();
    }
    return child;
  }
}
