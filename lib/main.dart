import 'package:flutter/material.dart';
import 'package:bus_reservation_system/home.dart';
import 'package:flutter/widgets.dart';

/*
Colors: 3DCAA0
F5F5F5
cfe6e6
 */
void main() {
  runApp(const MainApp());
}
/*
TODO: 1. Home Page
TODO: 2. Tickets
TODO: 3. Profile
TODO: 4. Map Route
 */

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bus Reservation System',
        theme: ThemeData(),
        color: Color(0xff3DCAA0),
        home: Scaffold(
          appBar: AppBar(
            title: Icon(Icons.pin_drop),
            backgroundColor: Color(0xff3DCAA0),
          ), // TODO: make this dynamic as well.
          body: Home(),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavBarItems,
            selectedItemColor: Colors.teal,
          ),
        ));
  }
}

const List<BottomNavigationBarItem> bottomNavBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.explore),
    label: 'Explore',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.confirmation_num),
    label: 'Tickets',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'Profile',
  ),
];
