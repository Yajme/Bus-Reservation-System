import 'package:bus_reservation_system/api.dart';
import 'package:bus_reservation_system/model/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import  'package:bus_reservation_system/model/globals.dart' as global;


class Map extends StatefulWidget {
  final Trip trip;
  const Map({super.key, required this.trip});
  @override
  MapState createState() => MapState();
}

class MapState extends State<Map> {


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
    } else {
      return Future.error('No Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    return Scaffold(
        appBar: AppBar(title: const Text('Route')),
        body: Column(children: [
          SizedBox(
              height: 400,
              child: FutureBuilder<Position>(
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
                        initialCenter: LatLng(trip.originCoordinates.latitude,
                            trip.originCoordinates.longitude),
                        onLongPress: (position, latlng) {
                          // Change the pin location
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName:
                              'dev.fleaflet.flutter_map.example',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                                //current location marker
                                point: trip.originCoordinates,
                                width: 50,
                                height: 50,
                                child: IconButton(
                                  icon: const Icon(Icons.location_on),
                                  onPressed: () {},
                                )),
                            Marker(
                                point:
                                    trip.destinationCoordinates, //<-Destination
                                width: 50,
                                height: 50,
                                child: IconButton(
                                  icon: const Icon(Icons.location_on),
                                  onPressed: () {},
                                )), //13.8841052,121.2643181
                          ],
                        ),
                        FutureBuilder<List<LatLng>>(
                            //LatLng(trip.originCoordinates.latitude, trip.originCoordinates.longitude)
                            future: getCoordinates(
                                "${trip.originCoordinates.longitude},${trip.originCoordinates.latitude}",
                                "${trip.destinationCoordinates.longitude},${trip.destinationCoordinates.latitude}"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                return PolylineLayer(
                                    
                                    //polylineCulling: false,
                                    polylines: [
                                      Polyline(
                                          points: snapshot.data!,
                                          color: Colors.blue,
                                          strokeWidth: 5)
                                    ]);
                              } else {
                                return const Center(
                                    child: Text('No data available'));
                              }
                            }),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              )),
          Expanded(
              child: SizedBox(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: .5),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Color(0xfff5f5f5),
              ),
              child: BusLineRoute(
                trip: trip,
              ), //TODO: ADD COMPONENTS
            ),
          )),
        ]));
  }
}

class BusLineRoute extends StatelessWidget {
  final Trip trip;
  BusLineRoute({super.key, required this.trip});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bus Line Route',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '8km', //Distance Covered
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),

          // First route stop
          Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Card(
                  color: Color(0xff3DCAA0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(children: [
                      const Icon(Icons.directions_bus, color: Colors.white),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.origin,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, d MMM yyyy h:mma')
                                .format(trip.departureDateTime),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                ),
              ),
            ],
          ),
          // Dotted line between stops
          const Padding(
              padding: EdgeInsets.only(left: 40),
              child: Dash(
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
                  color: Color(0xff3DCAA0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(children: [
                      Icon(Icons.location_on, color: Colors.white),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.destination,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, d MMM yyyy')
                                .format(trip.departureDateTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                ),
              ),
            ],
          ),
          // Add a button at the bottom
          Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context){
                      return SeatLayout(trip: trip);
                    });
                  },
                  child: Text('Select seats'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3DCAA0),
                    foregroundColor: Color(0xfff5f5f5),
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ))
        ],
      ),)
    );
  }
}

class SeatLayout extends StatefulWidget {
  final Trip? trip;
  SeatLayout({super.key, this.trip});
  @override
  State<SeatLayout> createState() => SeatLayoutState();
}

class SeatLayoutState extends State<SeatLayout> {
  final TextEditingController _seatController = new TextEditingController();
  Future<void> postData() async {
    final url = Uri.parse('https://bus-reservation-system-api.vercel.app/routes/book');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({
      "user_id" : "${global.user_id}",
      "route_id" : "${widget.trip!.id}",
      "seat_occupation" : _seatController.text
    });

    final response = await http.post(url, headers: headers, body: body);

var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking successful!'),
          backgroundColor: Colors.green,
        ),
      );
    }else{
ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${data['message']}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Container(
      child: Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.keyboard_arrow_down_outlined))
                ],),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _seatController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Number of Seats',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff3DCAA0),
                    foregroundColor: Color(0xfff5f5f5),
                    minimumSize: Size(double.infinity, 50),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Book Trip'),
                  onPressed: () async{
                    await postData();
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                 ) 
                 ) 
                 )
                    ],
                  ),
                )
              ])),
    )));
  }
}
