import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel_app/widgets/custom_icon_button.dart';
import 'package:travel_app/widgets/location_card.dart';
import 'package:travel_app/widgets/nearby_places.dart';
import 'package:travel_app/widgets/recommended_places.dart';
import 'package:travel_app/widgets/tourist_places.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http;
import '../models/boat_model.dart';
import '../models/login_response.dart';
import '../services/shared_service.dart';
import 'package:travel_app/config/config.dart';
import 'package:travel_app/models/locations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'boat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _id;
  String? _jwtToken;
  String getLocations = Config.getAllLocation;
  BoatData? _boatData;
  String? _greeting = '';
  bool _isLoading = true;
  String? _names;

  List<Location> _locations = []; // State variable to store the locations

  List<BoatData> _boatDataList = []; // Updated to hold a list of BoatData

  late Future<List<Location>> _futureLocations;

  Future<List<Location>> _fetchLocationsFromApi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('names');
    setState(() {
      _names = name;
    });
    final response = await http.get(Uri.parse(Config.getAllLocation));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Location> locations = jsonData
          .map((locationJson) => Location.fromJson(locationJson))
          .toList();

      // Store the locations in the state variable
      setState(() {
        _locations = locations;
      });
      _isLoading = false;
      return locations;
    } else {
      _isLoading = false;
      print(response.statusCode);
      throw Exception('Failed to load locations');
    }
  }
  // ... (existing code)

  Future<void> fetchBoatData() async {
    final response = await http.get(Uri.parse(getLocations));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);

      if (decodedData is List) {
        // If decodedData is a list, handle it accordingly
        List<BoatData> boatDataList = [];
        for (var item in decodedData) {
          boatDataList.add(BoatData.fromJson(item));
        }
        setState(() {
          _boatDataList =
              boatDataList; // Store all the boat items in _boatDataList
        });
        int i = 0;
        int j = 0;
        // for (i = 0; i < _boatDataList.length; i++) {
        //   print(_boatDataList[i].locationName);
        //   for (j = 0; j < _boatDataList[i].locationImages.length; j++) {
        //     print(_boatDataList[i].locationImages[j]);
        //   }
        // }
      } else if (decodedData is Map<String, dynamic>) {
        // If decodedData is a map, it means it's a single object (not a list)
        setState(() {
          _boatDataList = [
            BoatData.fromJson(decodedData)
          ]; // Store the single item in _boatDataList
        });
      } else {
        // Handle other data structures if necessary
        throw Exception('Invalid data structure');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;

    setState(() {
      if (hour >= 5 && hour < 12) {
        setState(() {
          _greeting = 'Good Morning';
        });
        _greeting = 'Good Morning';
      } else if (hour >= 12 && hour < 17) {
        _greeting = 'Good Afternoon';
      } else {
        _greeting = 'Good Evening';
      }
    });
  }

  Future<void> _checkUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print("token");
  }

  @override
  void initState() {
    super.initState();

    fetchBoatData();
    _futureLocations = _fetchLocationsFromApi();
    _updateGreeting();
    _checkUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Text("$_greeting"),
            Text(
              "$_names",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        actions: const [],
      ),
      body: FutureBuilder<List<Location>>(
        future: _futureLocations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView(
              children: [
                // Your other widgets here

                Padding(
                    padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _locations.length,
                      itemBuilder: (context, index) {
                        final location = _locations[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BoatsPage(id: location.id),
                                  ),
                                );
                              },
                              child: GridTile(
                                child: _isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Image.network(
                                        location.locationImage,
                                        fit: BoxFit.cover,
                                      ),
                                footer: Container(
                                  color: Colors.black54,
                                  child: Center(
                                    child: Text(
                                      location.locationName,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )),
              ],
            );
          }
        },
      ),
    );
  }
}
