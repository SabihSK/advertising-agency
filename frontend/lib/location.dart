// File: lib/main.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Location {
  final int id;
  final String name;
  final String description;
  final String latitude;
  final String longitude;

  Location({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class LocationListScreen extends StatefulWidget {
  @override
  _LocationListScreenState createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  late Future<List<Location>> futureLocations;

  @override
  void initState() {
    super.initState();
    futureLocations = fetchLocations();
  }

  Future<List<Location>> fetchLocations() async {
    var headers = {
      'Accept': 'application/json',
      'Authorization':
          'Basic e3tiYXNpY0F1dGhVc2VybmFtZX19Ont7YmFzaWNBdXRoUGFzc3dvcmR9fQ=='
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://10.0.2.2:8000/api/advertising-locations/')); // Use 10.0.2.2 for Android emulator

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      List<dynamic> jsonData = jsonDecode(responseData);
      return jsonData.map((data) => Location.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations'),
      ),
      body: FutureBuilder<List<Location>>(
        future: futureLocations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No locations found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final location = snapshot.data![index];
                return LocationCard(location: location, index: index);
              },
            );
          }
        },
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  final Location location;
  final int index;

  const LocationCard({required this.location, required this.index});

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      [Colors.pink, Colors.pinkAccent],
      [Colors.purple, Colors.deepPurpleAccent],
      [Colors.indigo, Colors.blueAccent],
    ][index % 3];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                location.description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Latitude: ${location.latitude}',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              Text(
                'Longitude: ${location.longitude}',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
