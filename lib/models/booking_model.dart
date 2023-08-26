import 'package:flutter/material.dart';

class BookingData {
  int boat;
  DateTime bookingDate;
  String bookingFrom;
  String bookingTo;
  String names;
  String phone;
  int? user;

  BookingData({
    required this.boat,
    required this.bookingDate,
    required this.bookingFrom,
    required this.bookingTo,
    required this.names,
    required this.phone,
    required this.user,
  });
}