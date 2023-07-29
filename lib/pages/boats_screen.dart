// import 'package:flutter/material.dart';
//
// import '../config/config.dart';
// import '../models/boat_model.dart';
// import 'package:travel_app/widgets/nearby_places.dart';
// import 'package:http/http.dart' as http;
// import '../models/login_response.dart';
// import '../services/shared_service.dart';
//
// import 'dart:convert';
//
// class BoatListPage extends StatefulWidget {
//   const BoatListPage({Key? key}) : super(key: key);
//
//   @override
//   State<BoatListPage> createState() => _BoatListPageState();
// }
//
// class _BoatListPageState extends State<BoatListPage> {
//   int? _id;
//   String? _jwtToken;
//   String getLocations = Config.getAllLocation;
//   BoatData? _boatData;
//
//   List<BoatData> _boatDataList = []; // Updated to hold a list of BoatData
//
//   // ... (existing code)
//
//   Future<void> fetchBoatData() async {
//     final response = await http.get(Uri.parse(getLocations));
//
//     if (response.statusCode == 200) {
//       final decodedData = json.decode(response.body);
//
//       if (decodedData is List) {
//         // If decodedData is a list, handle it accordingly
//         List<BoatData> boatDataList = [];
//         for (var item in decodedData) {
//           boatDataList.add(BoatData.fromJson(item));
//         }
//         setState(() {
//           _boatDataList =
//               boatDataList; // Store all the boat items in _boatDataList
//         });
//         int i = 0;
//         int j = 0;
//         for (i = 0; i < _boatDataList.length; i++) {
//           print(_boatDataList[i].price);
//           for (j = 0; j < _boatDataList[i].boatImages.length; j++) {
//             print("--------------------- boat images ---------------------");
//             print(_boatDataList[i].boatImages[j]);
//           }
//         }
//       } else if (decodedData is Map<String, dynamic>) {
//         // If decodedData is a map, it means it's a single object (not a list)
//         setState(() {
//           _boatDataList = [
//             BoatData.fromJson(decodedData)
//           ]; // Store the single item in _boatDataList
//         });
//       } else {
//         // Handle other data structures if necessary
//         throw Exception('Invalid data structure');
//       }
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   Future<void> _fetchInfo() async {
//     try {
//       LoginResponseModel? userDetails = await SharedService.loginDetails();
//       if (userDetails != null) {
//         String jwt = userDetails.jwtToken;
//         int id = userDetails.id;
//         setState(() {
//           _jwtToken = jwt;
//           _id = id;
//         });
//         print("token: $jwt");
//       }
//     } catch (e) {}
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchInfo();
//     fetchBoatData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 15,
//             ),
//             const Text("Good Morning"),
//             Text(
//               "Tetteh Jeron Asiedu",
//               style: Theme.of(context).textTheme.labelMedium,
//             ),
//           ],
//         ),
//         actions: const [],
//       ),
//       body: ListView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.all(14),
//         children: [
//           // LOCATION CARD
//
//           // CATEGORIES
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "All location to visit ",
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ],
//           ),
//
//           Container(
//             color: Color(0xFFFEFEFE),
//             child: ListView.builder(
//               itemCount: _boatDataList.length,
//               itemBuilder: (context, index) {
//                 return BoatCard(boatData: _boatDataList[index]);
//               },
//             ),
//           ),
//
//           const SizedBox(height: 10),
//           const NearbyPlaces(),
//           // BOAT DATA CONTAINER
//           if (_boatData != null)
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 // children: [
//                 //   // LOCATION CARD
//                 //   // ... (existing code)
//                 //
//                 //   // BOAT DATA CONTAINER
//                 //   ListView.builder(
//                 //     shrinkWrap: true,
//                 //     physics: NeverScrollableScrollPhysics(),
//                 //     itemCount: _boatDataList.length,
//                 //     itemBuilder: (context, index) {
//                 //       var boatData = _boatDataList[index];
//                 //       return Container(
//                 //         padding: EdgeInsets.all(16),
//                 //         decoration: BoxDecoration(
//                 //           color: Colors.white,
//                 //           borderRadius: BorderRadius.circular(10),
//                 //           boxShadow: [
//                 //             BoxShadow(
//                 //               color: Colors.grey.withOpacity(0.5),
//                 //               spreadRadius: 2,
//                 //               blurRadius: 5,
//                 //               offset: Offset(0, 3),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //         child: Column(
//                 //           crossAxisAlignment: CrossAxisAlignment.start,
//                 //           children: [
//                 //             Text(
//                 //               'Location Name: ${boatData.locationName}',
//                 //               style: TextStyle(
//                 //                   fontSize: 20, fontWeight: FontWeight.bold),
//                 //             ),
//                 //             SizedBox(height: 16),
//                 //             Text(
//                 //               'ID: ${boatData.id}',
//                 //               style: TextStyle(fontSize: 18),
//                 //             ),
//                 //             SizedBox(height: 16),
//                 //             Text(
//                 //               'Location Images:',
//                 //               style: TextStyle(
//                 //                   fontSize: 18, fontWeight: FontWeight.bold),
//                 //             ),
//                 //             SizedBox(height: 8),
//                 //             Container(
//                 //               height: 200,
//                 //               child: ListView.builder(
//                 //                 scrollDirection: Axis.horizontal,
//                 //                 itemCount: boatData.locationImages.length,
//                 //                 itemBuilder: (context, index) {
//                 //                   return Padding(
//                 //                     padding: EdgeInsets.all(8),
//                 //                     child: Image.network(
//                 //                       boatData.locationImages[index],
//                 //                       width: 200,
//                 //                       fit: BoxFit.cover,
//                 //                     ),
//                 //                   );
//                 //                 },
//                 //               ),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //       );
//                 //     },
//                 //   ),
//                 // ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
// class BoatCard extends StatelessWidget {
//   final BoatData boatData;
//
//   BoatCard({required this.boatData});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       child: Row(
//         children: [
//           Expanded(
//             flex: 1,
//             child: Image.network(boatData.boatImages[0]), // Display first image only
//           ),
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Maximum People: ${boatData.maxNumber}'),
//                   Text('Boat Price: \$${boatData.price}/hr'),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
