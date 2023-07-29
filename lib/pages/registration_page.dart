import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/config/config.dart';
import 'package:travel_app/pages/login_page.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String registerUserApi = Config.registerApiUser;
  String _responseMessage = '';
  DateTime? dob;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with registration
      final Map<String, dynamic> requestBody = {
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "dob": dob?.toIso8601String(), // Convert DateTime to ISO 8601 format
        "phoneNumber": phoneNumberController.text,
        "password": passwordController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(registerUserApi),
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Registration successful, show success modal
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Registration Successful'),
                content: Text('User registration completed successfully.'),
                actions: [
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
        title: Text('Registration Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dob != null
                    ? TextEditingController(
                        text: '${dob!.toLocal()}'.split(' ')[0])
                    : TextEditingController(),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dob ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != dob) {
                    setState(() {
                      dob = picked;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                ),
                validator: (value) {
                  if (dob == null) {
                    return 'Please select your date of birth';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 10) {
                    return 'Phone number should be 10 digits';
                  }
                  if (!value.startsWith('078') &&
                      !value.startsWith('079') &&
                      !value.startsWith('073') &&
                      !value.startsWith('072')) {
                    return 'Invalid phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Sign Up'),
              ),
              if (_responseMessage.isNotEmpty)
                Text(
                  _responseMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
