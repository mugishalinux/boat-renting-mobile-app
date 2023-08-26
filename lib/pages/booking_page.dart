import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/config/config.dart';
import 'package:travel_app/models/booking_model.dart';
import 'package:travel_app/pages/payment_page.dart';

class BookingPage extends StatefulWidget {
  final int boat;

  const BookingPage({Key? key, required this.boat}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookingDateController = TextEditingController();
  TimeOfDay _bookingFrom =
      TimeOfDay(hour: 8, minute: 0); // Default value for bookingFrom
  TimeOfDay _bookingTo =
      TimeOfDay(hour: 9, minute: 0); // Default value for bookingTo
  final TextEditingController _namesController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _responseMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _bookingDateController.dispose();
    _namesController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt('id');

      final BookingData _formData = BookingData(
        boat: widget.boat,
        bookingDate: DateTime.parse(_bookingDateController.text),
        bookingFrom:
            '${_bookingFrom.hour.toString().padLeft(2, '0')}:${_bookingFrom.minute.toString().padLeft(2, '0')}:00', // Format as "hh:mm:ss"
        bookingTo:
            '${_bookingTo.hour.toString().padLeft(2, '0')}:${_bookingTo.minute.toString().padLeft(2, '0')}:00', // Format as "hh:mm:ss"
        names: _namesController.text,
        phone: _phoneController.text,
        user: id,
      );

      if (_convertTimeToHour(_bookingFrom) >= _convertTimeToHour(_bookingTo)) {
        setState(() {
          _isLoading = false;
        });
        // Handle error: bookingFrom cannot be greater than or equal to bookingTo
        setState(() {
          _responseMessage =
              'Booking From cannot be greater than or equal to Booking To';
        });
        return;
      }

      final int diffHours = _bookingTo.hour - _bookingFrom.hour;

      try {
        final response = await http.post(
          Uri.parse(Config.bookingApi),
          body: json.encode({
            "boat": _formData.boat,
            "bookingDate": _formData.bookingDate.toIso8601String(),
            "bookingFrom": _formData.bookingFrom,
            "bookingTo": _formData.bookingTo,
            "diffHours": diffHours,
            "names": _formData.names,
            "phone": _formData.phone,
            "user": _formData.user,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 201) {
          setState(() {
            _isLoading = false;
          });
          // Success, do something with the response if needed
          print('Booking success: ${response.body}');
          final responseData = json.decode(response.body);
          print('Booking id: ${responseData['bookingId']}');

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Booking Successfully"),
                content: const Text(
                    "Your booking has been saved, to confirm it you need to pay."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                              bookingId: responseData['bookingId'],
                              amount: responseData['amountTobePaid']),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // Set the background color to blue
                    ),
                    child: const Text("Pay",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          // Handle error if needed
          final responseData = json.decode(response.body);
          print("error happened : ${responseData['message']}");
          setState(() {
            _responseMessage = "${responseData['message']}";
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
        });
        print('Error: $e');
      }
    }
  }

  int _convertTimeToHour(TimeOfDay time) {
    return time.hour;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      _bookingDateController.text = picked.toIso8601String();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Form'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Booking Date (DatePicker)
            TextFormField(
              controller: _bookingDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Booking Date',
              ),
              onTap: () => _selectDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a booking date';
                }
                return null;
              },
            ),

            // Booking From (Dropdown)
            DropdownButtonFormField<TimeOfDay>(
              value: _bookingFrom,
              onChanged: (value) {
                setState(() {
                  _bookingFrom = value!;
                });
              },
              items: List.generate(11, (index) {
                final hour = index + 8; // Start from 8:00 AM
                return DropdownMenuItem<TimeOfDay>(
                  value: TimeOfDay(hour: hour, minute: 0),
                  child: Text('$hour:00 AM'),
                );
              }),
              decoration: InputDecoration(
                labelText: 'Booking From',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please select a booking from time';
                }
                return null;
              },
            ),

            // Booking To (Dropdown)
            DropdownButtonFormField<TimeOfDay>(
              value: _bookingTo,
              onChanged: (value) {
                setState(() {
                  _bookingTo = value!;
                });
              },
              items: List.generate(10, (index) {
                final hour = index + 9; // Start from 9:00 AM
                return DropdownMenuItem<TimeOfDay>(
                  value: TimeOfDay(hour: hour, minute: 0),
                  child: Text('$hour:00 AM'),
                );
              }),
              decoration: InputDecoration(
                labelText: 'Booking To',
              ),
              validator: (value) {
                if (value == null) {
                  return 'Please select a booking to time';
                }
                return null;
              },
            ),

            // Names
            TextFormField(
              controller: _namesController,
              decoration: InputDecoration(
                labelText: 'Names',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter names';
                }
                return null;
              },
            ),

            // Phone
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }

                // Regular expression pattern for Airtel or MTN numbers
                final RegExp phonePattern = RegExp(r'^(07[8239])[0-9]{7}$');

                if (!phonePattern.hasMatch(value)) {
                  return 'Phone Number must be an Airtel or MTN number';
                }

                return null; // Validation passed
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 8.0,
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Book",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _responseMessage,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
