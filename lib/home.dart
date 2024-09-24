import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Widget _gap() => const SizedBox(height: 20);
  Widget findTicketCard(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
         border: Border.all(
          color: Color(0xff636E72),
          width: 0.3
         ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: -12,
              offset: const Offset(0,25),
              color: Color(0xff2D3436).withOpacity(.25)
              )
            ],
            borderRadius: BorderRadius.circular(15.0),
            color: const Color(0xfff5f5f5)),
        child: SizedBox(
          width: 300,
          height: 245,
          child:Column(
                children: [
            _gap(),
            const Center(
              child: Column(
                children: [
                  Text(
                    "Current Location",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    "Lipa City",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Destination",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    "Malvar, Batangas",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            _gap(),
            SizedBox(height: 40),
            // Button (for future actions)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
                child: Text('Find Tickets'),
              ),
            )
          ],
        )
        )
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3DCAA0),
      appBar: AppBar(
        backgroundColor: Color(0xff3DCAA0),
        title: Text(
            'Explore new place. Get new experience'), // TODO: change this to dynamic widget based on page
        centerTitle: true,
      ),
      body: Center(
          child: Stack(
        //alignment: AlignmentGeometry.lerp(a, b, t),
        clipBehavior: Clip.none,
        children: [
          //const SizedBox(height: 30),
          // Ticket Info Section
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 445,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Color(0xfff5f5f5)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
               
                    Positioned(
                      top: -250,
                      left:0,
                      right:0,
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child: SizedBox(
                              height: 245, child: findTicketCard(context))),
                    ),
                    Positioned( 
                      top: 90,
                      left:0,
                      right:0,
                      child: const CurrentBus())
                  ],
                ),
            ),
          ),
          //Positioned( bottom:50,child: const CurrentBus()),
        ],
      )),
    );
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
