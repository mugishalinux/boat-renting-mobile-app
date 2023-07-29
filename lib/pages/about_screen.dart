import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/login_response.dart';
import '../services/shared_service.dart';
import 'login_page.dart';
import 'navbar_state.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _status = 0;
  bool _isLoggedIn = false;

  Future<void> _fetchUserInfo() async {
    try {
      LoginResponseModel? userDetails = await SharedService.loginDetails();
      if (userDetails != null) {
        setState(() {});
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserInfo(); // call your function here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white, // set the color of the back arrow
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: Lottie.asset('assets/about.json'),
            ),
            const SizedBox(height: 16),
            const Text(
              'About us', // Replace with your app name
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Version 1.0.0', // Replace with your app version
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const Text(
              ' BoatRentalsNow: Your gateway to aquatic adventures! Browse, book, and enjoy a variety of boats hassle-free. Trusted owners, real-time availability, and 24/7 support. Start sailing today!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
