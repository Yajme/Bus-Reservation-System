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
        child:  const Center(
          child:SizedBox(
          height: 175,
          width: 305,
        ))
        ,
    )
    )
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