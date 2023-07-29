import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/config/config.dart';
import 'package:travel_app/pages/navbar_state.dart';
import 'package:travel_app/pages/registration_page.dart';
import 'package:travel_app/pages/reset_password.dart';
import '../config/config.dart';
import '../models/login_response.dart';
import '../services/shared_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _responseMessage = '';
  bool _isLoading = false;
  String loginApi = Config.loginApiUser;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _isLoading = false;
        _responseMessage = 'Please fill in all fields.';
      });
      return;
    }

    final phone = _phoneController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse(loginApi),
      body: jsonEncode({'phone': phone, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _isLoading = false;
      });
      final userData = jsonDecode(response.body);

      // Save user information to use in any screen
      // You can use a provider or other state management solution to store the data
      String error = '';
      String stg = response.body;
      Map<String, dynamic> jsonMap = jsonDecode(stg);
      LoginResponseModel user = LoginResponseModel.fromJson(jsonMap);
      // if (user.text != "client") {
      //   _isLoading = false;
      //   setState(() {
      //     _responseMessage = "Only client allowed to login";
      //   });
      //
      //   Future.delayed(const Duration(seconds: 3), () {
      //     setState(() {
      //       _responseMessage = '';
      //     });
      //   });
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   return;
      // }

      try {
        await SharedService.setLoginDetails(user);
      } catch (err) {
        if (kDebugMode) {
          print(error);
        }
      }

      _responseMessage = 'Login successful';
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavBar()),
        (Route<dynamic> route) => false,
      );
    } else {
      _isLoading = false;
      final errorData = jsonDecode(response.body);
      setState(() {
        _responseMessage = "invalid logins";
      });

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _responseMessage = '';
        });
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image and Curves
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/summer.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(80),
                        topRight: Radius.circular(80),
                      ),
                      child: Container(
                        height: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Login Form
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Color(0xFF0579ED)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Color(0xFF0579ED)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Container(
                          width: 200, // Set the desired width
                          child: ElevatedButton(
                            onPressed: () => _login(),
                            child: const Text('Login'),
                          ),
                        ),
                  const SizedBox(height: 10),
                  Text(
                    _responseMessage,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                    //child: Text('Don\'t have an account? Create'),
                    child: Text.rich(TextSpan(children: [
                      const TextSpan(text: "Don\'t have an account? "),
                      TextSpan(
                        text: ' Create Account',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationForm()));
                          },
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      ),
                    ])),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              //child: Text('Don\'t have an account? Create'),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: ' Reset Password',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResetPassword()));
                    },
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor),
                ),
              ])),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
