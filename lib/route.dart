import 'package:bus_reservation_system/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//TODO : Using Flutter map, utilize OpenRoute

class Map extends StatefulWidget {
  Map({super.key});
  @override
  MapState createState() => MapState();
}

class MapState extends State<Map> {
  Position? _currentPosition;


//* Getting Current Location
  Future<Position> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location Permission are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permanently denied');
      }

     return await Geolocator.getCurrentPosition();
     
    } catch (e) {
      return Future.error('Failed to get current location: $e');
    }
  }

  List listOfPoints = [];
  List<LatLng> points = [];


  Future<List<LatLng>> getCoordinates(startPoint, endPoint) async {
  
      var response = await http.get(getRouteUrl(startPoint, endPoint));
      
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          listOfPoints = data['features'][0]['geometry']['coordinates'];
          points = listOfPoints
              .map((e) => LatLng(e[1].toDouble(), e[0].toDouble()))
              .toList();

              return points;
        }else{
          return Future.error('No Data');
        }
     
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Route')),
        body: FutureBuilder<Position>(
          future: getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return FlutterMap(
                mapController: MapController(),
                options: MapOptions(
                  minZoom: 15,
                  initialCenter: LatLng(13.8841052, 121.2643181),
                  onLongPress: (position, latlng) {
                    // Change the pin location
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                          //current location marker
                          point: LatLng(snapshot.data!.latitude,
                              snapshot.data!.longitude),
                          width: 50,
                          height: 50,
                          child: IconButton(
                            icon: const Icon(Icons.location_on),
                            onPressed: () {},
                          )),
                      Marker(
                          point: LatLng(13.8841052, 121.2643181),
                          width: 50,
                          height: 50,
                          child: IconButton(
                            icon: const Icon(Icons.location_on),
                            onPressed: () {},
                          )), //13.8841052,121.2643181
                    ],
                  ),
                  
          FutureBuilder<List<LatLng>>(
              future: getCoordinates(
                  "${snapshot.data!.longitude},${snapshot.data!.latitude}",
                  "121.2643181,13.88410520"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return PolylineLayer(// TODO: wrap this with futurebuilder
                      //polylineCulling: false,
                      polylines: [
                    Polyline(points: snapshot.data!, color: Colors.blue, strokeWidth: 5)
                  ]);
                } else {
                  return const Center(child: Text('No data available'));
                }
              }),
                ],
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ));
  }
}
/*
if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) { } else { return const Center(child: Text('No data available'));}
 */
/*

*/