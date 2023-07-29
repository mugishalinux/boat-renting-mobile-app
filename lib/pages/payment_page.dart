import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final int bookingId;
  const PaymentPage(
      {super.key, required this.bookingId});
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PAYMENT"),),
    );
  }
}
