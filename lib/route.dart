import 'package:bus_reservation_system/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dash/flutter_dash.dart';
//TODO : Using Flutter map, utilize OpenRoute

class Map extends StatefulWidget {
  final LatLng destination;
  Map({super.key, required this.destination});
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
    final destination = widget.destination;
    return Scaffold(
        appBar: AppBar(title: const Text('Route')),
        body: Column( children: [
          SizedBox(
            height: 400,
            child:FutureBuilder<Position>(
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
                  minZoom: 10,
                  initialCenter: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
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
                          point: destination, //<-Destination
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
                  "${destination.longitude},${destination.latitude}"),
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
        )),
        Expanded(child:SizedBox(
          child: Container (
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black,width: .5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)
              ),
              color: Color(0xfff5f5f5),
            ),
            child: BusLineRoute(), //TODO: ADD COMPONENTS
           ),
        )),
        ])
        );
  }
}
class BusLineRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bus Line Route',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            
            // First route stop
            Row(
              children: [
               
                const SizedBox(width: 10),
                Expanded(
                  child: Card(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(children: [
                        Icon(Icons.directions_bus, color: Colors.white),
                        SizedBox(width: 15,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SM Lipa Grand Terminal',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Saturday, 21 Sept 2024 8:00am',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )]),
                    ),
                  ),
                ),
              ],
            ),
            // Dotted line between stops
           const Padding(padding: EdgeInsets.only(left: 40), child: Dash(
            direction: Axis.vertical,
            length: 30,
            dashLength: 4,
            dashColor: Colors.grey,
           )),
            // Second route stop
            Row(
              children: [
                
                
                SizedBox(width: 10),
                Expanded(
                  child: Card(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(children:[
                        Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: 15,),
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Drop-off Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Saturday, 21 Sept 2024 9:30am',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
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