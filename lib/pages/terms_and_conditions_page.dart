import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/login_response.dart';
import '../services/shared_service.dart';
import 'login_page.dart';
import 'navbar_state.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndConditions> {
  int _status = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white, // set the color of the back arrow
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Eligibility: Users must be at least 18 years old to access and use BoatRentalsNow.Boat Rentals: Boat availability is subject to change. Booking confirmation is required before rental.Safety: Users must follow all safety guidelines provided by boat owners. BoatRentalsNow is not liable for accidents or injuries.Payments: Users agree to pay rental fees and any applicable taxes. Payment processing is secure.Cancellation: Cancellation policies vary per boat. Refunds may be subject to cancellation fees.User Conduct: Users must act responsibly, adhere to local laws, and treat boats with care.Insurance: Boat owners are responsible for appropriate insurance coverage. BoatRentalsNow is not liable for damages.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
