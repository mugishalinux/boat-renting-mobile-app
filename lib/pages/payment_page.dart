import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'navbar_state.dart';
import 'package:travel_app/config/config.dart';

class PaymentPage extends StatefulWidget {
  final int bookingId;
  final int amount;

  const PaymentPage({
    Key? key,
    required this.bookingId,
    required this.amount,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _cardNameController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  String _responseMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      print('booking id : ${widget.bookingId}');
      print('user id : $id');
      print('amount  : ${widget.amount}');
      print('card  : ${_cardNumberController.text}');
      print('cvv  : ${_cvvController.text}');
      print('expire  : ${_expiryDateController.text}');

      final paymentData = {
        "booking": widget.bookingId,
        "user": id, // Hardcoded user ID
        "amount": widget.amount,
        "card": _cardNumberController.text,
        "cvv": _cvvController.text,
        "expire": _expiryDateController.text,
      };

      try {
        final response = await http.post(
          Uri.parse(Config.payingApi),
          body: json.encode({
            "booking": widget.bookingId,
            "user": id, // Hardcoded user ID
            "amount": widget.amount,
            "card": _cardNumberController.text,
            "cvv": _cvvController.text,
            "expire": _expiryDateController.text,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 201) {
          setState(() {
            _isLoading = false;
            _responseMessage = 'Payment Successful Done!';
          });

          // Show a pop-up modal with a success message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Payment Successful"),
                content: const Text("You have successfully paid."),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavBar(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          print("hello");
          final responseData = json.decode(response.body);
          String message = responseData['message'];
          print("error happened : $message");
          setState(() {
            _isLoading = false;
            _responseMessage = message;
          });
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              _responseMessage = '';
            });
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _responseMessage = 'Payment Failed. Please try again.';
        });
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PAYMENT"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  color: Colors.grey.shade700,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          "Amount to be paid : RWF ${widget.amount}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: _cardNameController,
                  decoration: const InputDecoration(
                    labelText: 'Card Name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextFormField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                    suffixIcon: Icon(Icons.credit_card),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter card number';
                    }
                    // Add card number validation logic here
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: _expiryDateController,
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter expiry date';
                          }
                          // Add expiry date validation logic here
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: _cvvController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter CVV number';
                          }
                          // Add CVV validation logic here
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(
                      child: SizedBox(
                          width: 50.0, // Adjust the width to make it smaller
                          height: 50.0, // Adjust the height to make it smaller
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          )))
                  : ElevatedButton(
                      onPressed: _pay,
                      child: const Text('PAY'),
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const NavBar()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Back'),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  _responseMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
