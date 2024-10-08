import 'package:flutter/material.dart';


class TripCard extends StatefulWidget{

final String pickupLocation;
final String destination;

final String departure;
final String arrival;

const TripCard({super.key, required this.pickupLocation,required this.destination, required this.arrival,required this.departure});
@override
  State<TripCard> createState() => StateTripCard();
}

class StateTripCard extends State<TripCard>{


String localityInitials(String locality){
  return "${locality[0]}${locality[locality.length~/2]}${locality[locality.length-1]}".toUpperCase();
}
@override
  Widget build(BuildContext context) {
    final pickupLocation = widget.pickupLocation;
    final destination = widget.destination;
    final departure = widget.departure;
    final arrival = widget.arrival; //TODO :remove arrival and replace with trip date
      return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xffF5F5F5),
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
                     pickupLocation,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      localityInitials(pickupLocation),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xff3DCAA0),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward, color: Colors.teal),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      destination,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      localityInitials(destination),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color:const Color(0xff3DCAA0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  departure,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  arrival, //TODO : Change to Trip date instead
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