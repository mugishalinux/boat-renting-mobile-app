import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/config/config.dart';
import 'package:lottie/lottie.dart';

import 'login_page.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? _responseMessage;
  String resetPasswordApi = Config.resetPasswordApi;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> requestBody = {
        "phoneNumber": phoneNumberController.text,
        "dob": int.parse(dobController.text),
        "password": passwordController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(resetPasswordApi),
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 201) {
          // Password reset successful, show success modal
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Reset Password'),
                content: Text('Password successfully updated.'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 130, 10, 0),
                    child: Center(
                      child: Lottie.asset(
                        'assets/icons/lockpassword.json',
                        fit: BoxFit.cover,
                        width:200,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        } else {
          final errorData = jsonDecode(response.body);
          setState(() {
            _responseMessage = errorData['message'] ?? 'Unknown error occurred';
          });
        }
      } catch (e) {
        setState(() {
          _responseMessage = 'An error occurred: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dobController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Year of Birth',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your year of birth';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text('Reset Password'),
              ),
              if (_responseMessage != null)
                Center(
                  child: Text(
                    _responseMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
