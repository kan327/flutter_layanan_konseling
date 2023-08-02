import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layanan_konseling/network/api.dart';
import 'package:layanan_konseling/screen/homepage.dart';
// import 'package:uji_level_bk/main.dart';
import 'package:layanan_konseling/utils/colors.dart';
import 'package:layanan_konseling/utils/text_field_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _secureText = true;
  late SharedPreferences sharedPreferences;
  bool isAuth = false;
  void _checkIfLoggedIn() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    if (token != null) {
      if (mounted) {
        setState(() {
          isAuth = true;
        });
      }
    }
    if (isAuth) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Homepage(),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  // Membuat fungsi _showMsg untuk menampilkan pesan pada snackbar
  _showMsg(String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Flexible(flex: 1, child: Container()),
        Center(
          child: Image(
            image: AssetImage('img/password_screen.png'),
            width: MediaQuery.of(context).size.width / 2 > 400
                ? 400
                : MediaQuery.of(context).size.width / 2,
            fit: BoxFit.contain,
          ),
        ),
        Flexible(flex: 1, child: Container()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back!",
                textAlign: TextAlign.left,
                style: GoogleFonts.nunito(
                    color: bluePrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Text.rich(
                TextSpan(
                  text: 'Login with your account ',
                  style: GoogleFonts.nunito(
                    color: accGrey,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: 'DeepTalk.',
                      style: GoogleFonts.nunito(
                          color: bluePrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    TextFieldInput(
                      hintText: "Enter Your Email",
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                      icon: const Icon(
                        Icons.email,
                        color: accGrey,
                      ),
                    ),
                    TextFieldInput(
                      hintText: "Enter Your Password",
                      textInputType: TextInputType.text,
                      textEditingController: _passwordController,
                      isPass: true,
                      icon: const Icon(
                        Icons.lock,
                        color: accGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Ink(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: bluePrimary,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: InkWell(
                  onTap: _login,
                  splashColor: accGrey, // Warna animasi saat ditap
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 8, 12, 8),
                    child: Text(
                      _isLoading ? "Loading" : "Login",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: whiteFont,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(flex: 2, child: Container()),
      ]),
    ));
  }

  void _login() async {
    var email = null;
    var password = null;
    setState(() {
      _isLoading = true;
    });

    email = _emailController.text;
    password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // Jika email atau password kosong, tampilkan pesan kesalahan
      _showMsg("Email and password tidak boleh kosong");
      setState(() {
        _isLoading = false;
      });
      return; // Hentikan eksekusi fungsi login
    }

    var data = {
      'email': email,
      'password': password,
      'device_name': 'Emulator'
    };

    final res = await Network().postRequest(
      route: '/login',
      data: data,
    );

    final response = jsonDecode(res.body);

    if (response['status'] == 200) {
      _showMsg(response['messages'].toString());
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt("userId", response['data']['user']['id']);
      await preferences.setString("userName", response['data']['user']['nama']);
      await preferences.setString(
          "profile", response['data']['user']['profile']);
      await preferences.setString(
          "userEmail", response['data']['user']['email']);
      await preferences.setString("token", response['data']['token']);

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Homepage(user: response['data']['user']),
      ));
    } else {
      // print(response);
      _showMsg(response['data']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
