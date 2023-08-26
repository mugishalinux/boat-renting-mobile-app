import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/pages/tourist_details_page.dart';
import '../models/boat_model.dart';
import 'package:travel_app/config/config.dart';

import '../widgets/nearby_places.dart';

class BoatsPage extends StatefulWidget {
  final int? id;
  const BoatsPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<BoatsPage> createState() => _BoatsPageState();
}

class _BoatsPageState extends State<BoatsPage> {
  List<BoatData> _boats = []; // State variable to store the locations

  List<BoatData> _boatDataList = []; // Updated to hold a list of BoatData

  late Future<List<BoatData>> _futureBoatData;

  Future<void> fetchBoatData() async {
    final response =
        await http.get(Uri.parse('${Config.getAllBoats}/${widget.id}'));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);

      if (decodedData is List) {
        List<BoatData> boatDataList = [];
        for (var item in decodedData) {
          boatDataList.add(BoatData.fromJson(item));
        }
        setState(() {
          _boatDataList = boatDataList;
        });
      } else if (decodedData is Map<String, dynamic>) {
        setState(() {
          _boatDataList = [
            BoatData.fromJson(decodedData),
          ];
        });
      } else {
        throw Exception('Invalid data structure');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBoatData();
    // _futureBoatData = _fetchBoatsFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(
        title: const Text('Boat List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_boatDataList.isEmpty)
              const Center(
                child: Text(
                  'No boats available for this location',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            for (var boatData in _boatDataList) BoatCard(boatData: boatData),
          ],
        ),
      ),
    );
  }
}

class BoatCard extends StatelessWidget {
  final BoatData boatData;

  BoatCard({required this.boatData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TouristDetailsPage(
                boatData: boatData,
              ),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 2, 0, 2),
                  child: Image.network(boatData.boatImages[0]),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maximum People: ${boatData.maxNumber}',
                        style: const TextStyle(color: Colors.black),
                      ),
                      Text(
                        "Boat Price: RWF ${boatData.price}/hr",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
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
