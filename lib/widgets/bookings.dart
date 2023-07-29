import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel_app/config/config.dart';
import 'package:travel_app/models/booking_report.dart';

class Bookings extends StatefulWidget {
  const Bookings({
    Key? key,
  }) : super(key: key);

  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  List<BookingData> _bookingList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('${Config.bookingListApi}/1'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          _bookingList = responseData
              .map((data) => BookingData(
                    id: data['id'],
                    bookingRef: data['bookingRef'],
                    bookingDate: DateTime.parse(data['bookingDate']),
                    bookingFrom: data['bookingFrom'],
                    bookingTo: data['bookingTo'],
                    names: data['names'],
                    phoneNumber: data['phoneNumber'],
                    paymentStatus: data['paymentStatus'],
                  ))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatBookingDate(DateTime bookingDate) {
    final format = DateFormat('MMMM d, y');
    return format.format(bookingDate);
  }

  void _showBookingDetails(
    int bookingId,
    DateTime bookingDate,
    String bookingFrom,
    String bookingTo,
    String names,
    String? paymentStatus,
    String phoneNumber,
  ) {
    // Convert the DateTime to a formatted string
    String formattedDate = DateFormat('yyyy-MM-dd').format(bookingDate);

    // Show the booking details in a pop-up modal
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Booking Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking ID: $bookingId'),
                SizedBox(height: 10),
                Text('Booking Date: $formattedDate'),
                SizedBox(height: 10),
                Text('Booking From: $bookingFrom'),
                SizedBox(height: 10),
                Text('Booking To: $bookingTo'),
                SizedBox(height: 10),
                Text('Names: $names'),
                SizedBox(height: 10),
                Text('Payment Status: ${paymentStatus ?? 'No payment'}'),
                SizedBox(height: 10),
                Text('Phone Number: $phoneNumber'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataTable() {
    return DataTable2(
      columnSpacing: 20,
      minWidth: 600,
      sortColumnIndex: 0,
      sortAscending: true,
      columns: [
        DataColumn2(
          label: const Text('Reference '),
          size: ColumnSize.S,
          numeric: true,
          onSort: (columnIndex, ascending) {
            setState(() {
              _bookingList.sort((a, b) => ascending
                  ? a.bookingRef.compareTo(b.bookingRef)
                  : b.bookingRef.compareTo(a.bookingRef));
            });
          },
        ),
        DataColumn2(
          label: Text('Booking Date'),
          size: ColumnSize.M,
          onSort: (columnIndex, ascending) {
            setState(() {
              _bookingList.sort((a, b) => ascending
                  ? a.bookingDate.compareTo(b.bookingDate)
                  : b.bookingDate.compareTo(a.bookingDate));
            });
          },
        ),
        DataColumn2(
          label: Text('Status'),
          size: ColumnSize.S,
          numeric: false,
          onSort: (columnIndex, ascending) {
            // You can implement sorting logic here if needed
          },
        ),
        DataColumn2(
          label: Text('Actions'),
          size: ColumnSize.L,
          onSort: (columnIndex, ascending) {
            setState(() {
              _bookingList.sort((a, b) => ascending
                  ? a.names.compareTo(b.names)
                  : b.names.compareTo(a.names));
            });
          },
        ),
      ],
      rows: _bookingList.map((data) {
        return DataRow(cells: [
          DataCell(Text(data.bookingRef.toString())),
          DataCell(Text(_formatBookingDate(data.bookingDate))),
          DataCell(Text(
            data.paymentStatus != null ? data.paymentStatus! : 'No Payment',
            style: TextStyle(
              color: data.paymentStatus == 'success'
                  ? Colors.green
                  : data.paymentStatus == 'pending'
                      ? Colors.blue
                      : data.paymentStatus == 'failed'
                          ? Colors.red
                          : Colors.black,
            ),
          )),
          DataCell(TextButton(
            onPressed: () {
              _showBookingDetails(
                  data.id,
                  data.bookingDate,
                  data.bookingFrom,
                  data.bookingTo,
                  data.names,
                  data.paymentStatus,
                  data.phoneNumber);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              side: MaterialStateProperty.all(
                  const BorderSide(color: Colors.blue)),
            ),
            child: const Text(
              "View details",
              style: TextStyle(color: Colors.blue),
            ),
          )

              // const TextBox.fromLTRBD("View details"),

              ),
        ]);
      }).toList(),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: DataTable2(
        columnSpacing: 20,
        minWidth: 600,
        columns: const [
          DataColumn2(label: Text('Booking Ref')),
          DataColumn2(label: Text('Booking Date')),
          DataColumn2(label: Text('Names')),
          DataColumn2(label: Text('Payment Status')),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
          ]),
          DataRow(cells: [
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
            DataCell(Text('')),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking List'),
      ),
      body: _isLoading
          ? _buildShimmer()
          : (_bookingList.isEmpty
              ? const Center(child: Text('No bookings made'))
              : _buildDataTable()),
    );
  }
}
