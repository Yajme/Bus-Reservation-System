import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:bus_reservation_system/components/card.dart';
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

      Placemark place = placemarks[0];

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
                    HeaderText(text: 'Current Bus'),
                    TripCard(pickupLocation: "Lipa", destination: "Malvar", arrival: "9:30am", departure: "8:00am"),
                    SizedBox(
                      height: 15,
                    ),
                    HeaderText(text: 'Upcoming Trip'),
                    const CurrentBus(),
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
                    controller: _currentLocation,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      labelText: 'Current Location',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(13),
                  child: TextFormField(
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
                        child: TextField(
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
                        child: TextField(
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
                        //redirect to tickets but with filter
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3DCAA0),
                        foregroundColor: Color(0xfff5f5f5),
                        minimumSize: Size(double.infinity, 50),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: const Text("Search Trips"),
                    )),
              ],
            )));
  }
}

class CurrentBus extends StatelessWidget {
  const CurrentBus({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lipa City",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "LPC",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward, color: Colors.teal),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Malvar, Batangas",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "MLV",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "8:00 AM",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  "9:30 AM",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
