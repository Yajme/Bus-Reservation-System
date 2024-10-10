import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bus_reservation_system/route.dart';
import 'package:latlong2/latlong.dart';
import 'package:bus_reservation_system/components/card.dart';
import 'package:bus_reservation_system/model/trip_model.dart';
import 'package:bus_reservation_system/model/route_model.dart' as route;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:bus_reservation_system/components/filter.dart';
//TODO : ListView of Cards

class TicketList extends StatefulWidget {
  final Filter? filter;
   TicketList({super.key, this.filter});
  @override
  State<TicketList> createState() => TicketListState();
}

class TicketListState extends State<TicketList> {
  late Future<List<route.Route>?> _futureRoutes;
  TextEditingController _dateController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _busLineController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _loadRoutes(widget.filter);

  }
void _loadRoutes(Filter? filter) {
    setState(() {
      _futureRoutes = loadAvailableTickets(filter);
    });
  }

  
  Future<List<route.Route>?> loadAvailableTickets(Filter? _filter) async {
    final filter = _filter;
    String request;
    if(filter != null){
final date = DateFormat('MMMM d, yyyy').format(filter.tripDate); 
     request = '/routes/search?destination=${filter.destination}&date=$date';
    if(filter.currentLocation != null){
      request += '&current_location=${filter.currentLocation}';
    }
    if(filter.seats != null){
      request += '&seat=${filter.seats}';
    }

    if(filter.preferredBus != null){
      request +='&bus_line=${filter.preferredBus}';
    }
    }else{
      request = '/routes/available';
    }

    final response = await http.get(Uri.parse('https://bus-reservation-system-api.vercel.app$request'));
        print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<route.Route> available =
          data.map((json) => route.Route.fromJson(json)).toList();

      return available;
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
    return Scaffold(
      appBar: AppBar(
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            Center(child: Text("Tickets Available")),
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                icon: Icon(Icons.more_horiz_outlined, color: Colors.black),
                onPressed: () {
                  // Handle button press
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                            child: SingleChildScrollView(child:Container(
                                padding: EdgeInsets.all(0),
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(Icons
                                                  .keyboard_arrow_down_outlined))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: TextFormField(
                                          controller: _destinationController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0))),
                                              labelText: 'Destination'),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: TextField(
                                          controller: _dateController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                            ),
                                            labelText: 'Date',
                                            prefixIcon:
                                                Icon(Icons.calendar_today),
                                          ),
                                          readOnly: true,
                                          onTap: () {
                                            _selectDate();
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: TextFormField(
                                          controller: _busLineController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0))),
                                              labelText: 'Preferred Bus Line'),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle search trips action
                                            //redirect to tickets but with filter
                                            _loadRoutes(
                                              Filter(destination: _destinationController.text,
                                              preferredBus: _busLineController.text,
                                              tripDate: DateTime.parse(_dateController.text)
                                              )
                                            );
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff3DCAA0),
                                            foregroundColor: Color(0xfff5f5f5),
                                            minimumSize:
                                                Size(double.infinity, 50),
                                            textStyle: TextStyle(fontSize: 16),
                                          ),
                                          child: const Text("Search Trips"),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle search trips action
                                            //redirect to tickets but with filter
                                            _loadRoutes(widget.filter);
                                           
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xfff5f5f5),
                                            foregroundColor: Color(0xff3DCAA0),
                                            minimumSize:
                                                Size(double.infinity, 50),
                                            textStyle: TextStyle(fontSize: 16),
                                          ),
                                          child: const Text("Clear Filter"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))));
                      });
                },
              ),
            ),
          ])),
      body: SingleChildScrollView(
          child: FutureBuilder<List<route.Route>?>(
        future: _futureRoutes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Ticket Found'));
          } else {
            return ListView.builder(
              shrinkWrap: true, // Set to true to avoid infinite height issue
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return TicketCard(
                    busLine: snapshot.data![index].bus!.busLine!.toLowerCase(),
                    remainingSeat: snapshot.data![index].availableSeats!,
                    totalSeat: snapshot.data![index].bus!.totalSeats!,
                    trip: Trip(
                      id: snapshot.data![index].id,
                        origin: snapshot.data![index].origin!,
                        departureDateTime: convertToDateTime(
                            snapshot.data![index].tripDate!.seconds!,
                            snapshot.data![index].tripDate!.nanoseconds!),
                        destination: snapshot.data![index].destination!,
                        destinationCoordinates: LatLng(
                            snapshot
                                .data![index].destinationCoordinates!.latitude!,
                            snapshot.data![index].destinationCoordinates!
                                .longitude!),
                        originCoordinates: LatLng(
                            snapshot.data![index].originCoordinates!.latitude!,
                            snapshot
                                .data![index].originCoordinates!.longitude!)));
              },
            );
          }
        },
      )),
    );
  }
}

class TicketCard extends StatefulWidget {
  //TODO: Create Properties
  final String busLine;
  final int remainingSeat;
  final int totalSeat;
  final Trip trip;

  TicketCard(
      {required this.busLine,
      required this.remainingSeat,
      required this.totalSeat,
      required this.trip});
  @override
  State<TicketCard> createState() => TicketCardState();
}

class TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    final busLine = widget.busLine;
    final remainingSeat = widget.remainingSeat;
    final totalSeat = widget.totalSeat;
    final trip = widget.trip;
    return Padding(
      padding: const EdgeInsets.all(25),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Map(
                          trip: trip, //Change this to Destination
                        )));
          },
          child: Center(
              child: SizedBox(
            height: 250,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        spreadRadius: -12,
                        offset: const Offset(0, 25),
                        color: Color(0xff2D3436).withOpacity(.25))
                  ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            // change based on liner
                            'https://bus-reservation-system-api.vercel.app/assets/image/$busLine.png',
                            fit: BoxFit.contain,
                            scale: 0.5, // Adjust as necessary
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(right: 25),
                          child:
                              Chip(label: Text('$remainingSeat/$totalSeat'))),
                    ],
                  ),
                  TripCard(
                      pickupLocation: trip.origin,
                      destination: trip.destination,
                      arrival: DateFormat('MMMM d, yyyy')
                          .format(trip.departureDateTime),
                      departure: DateFormat('h:mma')
                          .format(trip.departureDateTime)
                          .toLowerCase()),
                ],
              ),
            ),
          ))),
    );
  }
}
