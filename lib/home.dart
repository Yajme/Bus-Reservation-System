import 'package:bus_reservation_system/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:bus_reservation_system/components/card.dart';
import 'package:provider/provider.dart';
import 'package:bus_reservation_system/tickets.dart';
import 'package:bus_reservation_system/components/filter.dart';
import 'package:bus_reservation_system/model/globals.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bus_reservation_system/model/trip_json_model.dart';
class Home extends StatefulWidget {
  
  Home({super.key});

  @override
  State<Home> createState() => StateHome();
}

class StateHome extends State<Home> {
  String _locationMessage = '';

  Placemark? _placemark;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    
  }



  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      

      setState(() {
        _placemark = placemarks[0]; // Update the Placemark property
        _locationMessage =
            "${_placemark!.locality}, ${_placemark!.subAdministrativeArea},${_placemark!.name}";
      });
    } catch (e) {
      print("error: $e");
      setState(() {
        _locationMessage = "$e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff3DCAA0),
        appBar: AppBar(
            backgroundColor: Color(0xff3DCAA0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('EEEE, d MMMM y').format(DateTime.now())),
                SizedBox(
                  height: 5,
                ),
                Row(children: [
                  Opacity(
                    opacity: 0.5,
                    child: Icon(
                      Icons.location_pin,
                      size: 12,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    _locationMessage,
                    style: TextStyle(color: Color(0xfff5f5f5).withOpacity(0.5)),
                  )
                ])
              ],
            )),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 445,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    color: Color(0xfff5f5f5)),
                child:SingleChildScrollView(child:  Column(
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    const HeaderText(text: 'Current Bus'),
                    const CurrentBus(),
                    SizedBox(
                      height: 15,
                    ),
                    const HeaderText(text: 'Upcoming Trip'),
                    const UpcomingTrip(),
                  ],
                ),
              ),
            ),),
            Positioned(
                left: 0,
                right: 0,
                top: 75,
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: _placemark != null
                      ? FindTicket(placemark: _placemark!)
                      : CircularProgressIndicator(),
                )),
          ],
        ));
  }
}

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft, // Aligns the text to the left
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        ));
  }
}

class FindTicket extends StatefulWidget {
  final Placemark placemark;

  FindTicket({super.key, required this.placemark});

  @override
  State<FindTicket> createState() => StateFindTicket();
}

class StateFindTicket extends State<FindTicket> {
  TextEditingController _dateController = TextEditingController();
  final TextEditingController _currentLocation = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  final TextEditingController _seats = TextEditingController();
  final FocusNode _currentLocationFocusNode = FocusNode();
  Widget _gap() => const SizedBox(height: 20);
  @override
  Widget build(BuildContext context) {
    final placemark = widget.placemark;
    setState(() {
      //subAdministrativeArea == Province
      //administrativeArea == Region
      _currentLocation.text =
          "${placemark.locality},${placemark.subAdministrativeArea}";
    });
    Future<void> _selectDate() async {
      DateTime? _picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100));

      if (_picked != null) {
        setState(() {
          _dateController.text = _picked.toString().split(" ")[0];
        });
      }
    }

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff636E72), width: 0.3),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: -12,
                  offset: const Offset(0, 25),
                  color: Color(0xff2D3436).withOpacity(.25))
            ],
            borderRadius: BorderRadius.circular(15.0),
            color: const Color(0xfff5f5f5)),
        child: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(9),
                  child: TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Enter Current Location';
                      }

                      return null;
                    },
                    focusNode: _currentLocationFocusNode,
                    controller: _currentLocation,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      labelText: 'Current Location',
                    ),
                    autofocus: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(13),
                  child: TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please enter destination';
                      }
                      return null;
                    },
                    controller: _destination,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      labelText: 'Destination',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if(value == null || value.isEmpty){
                              return 'Enter a date';
                            }
                            return null; 
                          },
                          controller: _dateController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            labelText: 'Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () {
                            _selectDate();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Enter seats';
                            }

                            return null;
                          },
                          controller: _seats,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            labelText: 'Seat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(3),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle search trips action
                        // Create a Filter object
                        
            Filter filter = Filter(
              tripDate: DateTime.parse(_dateController.text),
              destination: _destination.text,
              currentLocation: _currentLocation.text,
              seats: int.tryParse(_seats.text),
            );

            // Change to the tab with index 1 and pass the filter
            Provider.of<TabIndex>(context, listen: false).changeIndex(1);

            // Navigate to TicketList with the filter
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TicketList(filter: filter),
              ),
            );


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3DCAA0),
                        foregroundColor: Color(0xfff5f5f5),
                        minimumSize: Size(double.infinity, 50),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: const Text("Search Trips"),
                    )
                    ),
              ],
            )));
  }
}

class UpcomingTrip extends StatelessWidget{
  const UpcomingTrip({super.key});

  Future<Trip?> loadTrip()async{
   final user_id =  global.user_id;
   final role = global.role;

   final request = '/ticket/search?role=$role&user_id=$user_id&filter=upcoming trip';
   final response = await http.get(Uri.parse('https://bus-reservation-system-api.vercel.app$request'));
   if(response.statusCode == 200){
    final Map<String, dynamic> data = json.decode(response.body);

      Trip trip = Trip.fromJson(data);

      return trip;
   }

   return null;
  }
  DateTime convertToDateTime(int seconds, int nanoseconds) {
    // Convert seconds to milliseconds
    int millisecondsFromSeconds = seconds * 1000;

    // Convert nanoseconds to milliseconds (1 nanosecond = 1/1,000,000 millisecond)
    int millisecondsFromNanoseconds = nanoseconds ~/ 1000000;

    // Combine both to get total milliseconds since the Unix epoch
    int totalMilliseconds =
        millisecondsFromSeconds + millisecondsFromNanoseconds;

    // Create DateTime object from milliseconds since epoch
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(totalMilliseconds);

    return dateTime;
  }
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(future: loadTrip(), builder: (context,snapshot){
       if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Padding(padding: EdgeInsets.all(25), child: Center(child:Text('No Upcoming Trip')));
          } else {
            DateTime dateTime = convertToDateTime(
                            snapshot.data!.route!.tripDate!.seconds!,
                            snapshot.data!.route!.tripDate!.nanoseconds!);
            return TripCard(pickupLocation: snapshot.data!.route!.origin!, destination: snapshot.data!.route!.destination!, arrival: DateFormat('MMMM d, yyyy')
                          .format(dateTime), departure: DateFormat('h:mma')
                          .format(dateTime)
                          .toLowerCase());
          }
    });
  }
}
class CurrentBus extends StatelessWidget {
  const CurrentBus({super.key});

  Future<Trip?> loadTrip()async{
   final user_id =  global.user_id;
   final role = global.role;

   final request = '/ticket/search?role=$role&user_id=$user_id&filter=current bus';
   final response = await http.get(Uri.parse('https://bus-reservation-system-api.vercel.app$request'));
   if(response.statusCode == 200){
    final Map<String, dynamic> data = json.decode(response.body);

      Trip trip = Trip.fromJson(data);

      return trip;
   }

   return null;
  }
  DateTime convertToDateTime(int seconds, int nanoseconds) {
    // Convert seconds to milliseconds
    int millisecondsFromSeconds = seconds * 1000;

    // Convert nanoseconds to milliseconds (1 nanosecond = 1/1,000,000 millisecond)
    int millisecondsFromNanoseconds = nanoseconds ~/ 1000000;

    // Combine both to get total milliseconds since the Unix epoch
    int totalMilliseconds =
        millisecondsFromSeconds + millisecondsFromNanoseconds;

    // Create DateTime object from milliseconds since epoch
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(totalMilliseconds);

    return dateTime;
  }
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(future: loadTrip(), builder: (context,snapshot){
       if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Padding(padding: EdgeInsets.all(25), child: Center(child:Text('No Current Trip')));
          } else {
            DateTime dateTime = convertToDateTime(
                            snapshot.data!.route!.tripDate!.seconds!,
                            snapshot.data!.route!.tripDate!.nanoseconds!);
            return TripCard(pickupLocation: snapshot.data!.route!.origin!, destination: snapshot.data!.route!.destination!, arrival: DateFormat('MMMM d, yyyy')
                          .format(dateTime), departure: DateFormat('h:mma')
                          .format(dateTime)
                          .toLowerCase());
          }
    });
  }
}
