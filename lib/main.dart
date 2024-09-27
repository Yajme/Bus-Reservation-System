import 'package:flutter/material.dart';
import 'package:bus_reservation_system/home.dart';
import 'package:bus_reservation_system/tickets.dart';
import 'package:bus_reservation_system/profile.dart';
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
  //CurrentIndex of page
  int _selectedIndex = 0;

  // List of pages to display
  final List<Widget> _pages = [
    Home(),
    TicketList(),
    ProfilePage(), //<- Replace with Profile Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bus Reservation System',
        theme: ThemeData(
          primaryColor: Color(0xff3DCAA0),
          appBarTheme:  const AppBarTheme(
            titleTextStyle: TextStyle(color: Color(0xfff5f5f5)),
            backgroundColor: Color(0xff3DCAA0),
            iconTheme: IconThemeData(color: Colors.white)
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey
          ),
        ),
        home: Scaffold(
           resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: bottomNavBarItems,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            )
            )
            );
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
