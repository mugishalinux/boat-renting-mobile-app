import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:travel_app/config/config.dart';
import 'package:travel_app/pages/payment_page.dart';

import '../models/booking_model.dart';

class BookingPage extends StatefulWidget {
  final int boat;
  const BookingPage(
      {super.key, required this.boat}); // Add this line to the constructor
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookingDateController = TextEditingController();
  final TextEditingController _bookingFromController = TextEditingController();
  final TextEditingController _bookingToController = TextEditingController();
  final TextEditingController _namesController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _bookingDateController.dispose();
    _bookingFromController.dispose();
    _bookingToController.dispose();
    _namesController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submission
      final BookingData _formData = BookingData(
        boat: 0, // Replace with the boat ID
        bookingDate: DateTime.parse(_bookingDateController.text),
        bookingFrom: _convertTimeStringToTimeOfDay(_bookingFromController.text),
        bookingTo: _convertTimeStringToTimeOfDay(_bookingToController.text),
        names: _namesController.text,
        phone: _phoneController.text,
        user: 0, // Replace with the user ID
      );

      try {
        final response = await http.post(
          Uri.parse(Config.bookingApi),
          body: {
            "boat": "${widget.boat.toString()} , ${1}",
            "bookingDate": _formData.bookingDate.toIso8601String(),
            "bookingFrom": _formData.bookingFrom.format(context),
            "bookingTo": _formData.bookingTo.format(context),
            "names": _formData.names,
            "phone": _formData.phone,
          },
        );

        if (response.statusCode == 201) {
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
                          builder: (context) =>
                              PaymentPage(bookingId: responseData['bookingId']),
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
          // Handle error if needed
          final responseData = json.decode(response.body);
          print('Booking failed: ${responseData['message']}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  TimeOfDay _convertTimeStringToTimeOfDay(String timeString) {
    final components = timeString.split(' ');
    final time = TimeOfDay(
      hour: int.parse(components[0].split(':')[0]),
      minute: int.parse(components[0].split(':')[1]),
    );
    return components[1].toLowerCase() == 'pm' && time.hour != 12
        ? TimeOfDay(hour: time.hour + 12, minute: time.minute)
        : time;
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

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      controller.text = picked.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Form'),
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

            // Booking From (TimePicker)
            TextFormField(
              controller: _bookingFromController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Booking From',
              ),
              onTap: () => _selectTime(context, _bookingFromController),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a booking from time';
                }
                return null;
              },
            ),

            // Booking To (TimePicker)
            TextFormField(
              controller: _bookingToController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Booking To',
              ),
              onTap: () => _selectTime(context, _bookingToController),
              validator: (value) {
                if (value == null || value.isEmpty) {
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
                  return 'Please enter phone number';
                }
                return null;
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 8.0,
                ),
              ),
              child: const Text("Book"),
            ),
          ],
        ),
      ),
    );
  }
}
