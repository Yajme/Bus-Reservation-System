import 'package:flutter/material.dart';
import 'package:bus_reservation_system/route.dart';

//TODO : ListView of Cards
class TicketList extends StatelessWidget{
  const TicketList ({super.key});

  Widget cards(BuildContext context){
    return Padding( // TODO: wrap this with GestureDetector
      padding: const EdgeInsets.all(25),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> Map()));
        },
      child:Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black
        )
        ),
        child:   Center(
          child:SizedBox(

          height: 175,
          width: 305,
          child:  Column(
          children: [
            SizedBox(height: 30,),
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
    )
        ))
        ,
    
    
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child:Text("Tickets Available"))),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            cards(context),
          ],
        ),
      ),
      
    );
  }
}