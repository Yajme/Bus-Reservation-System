import 'package:flutter/material.dart';
import 'package:bus_reservation_system/driver/driver_profile.dart';
class Home extends StatefulWidget {

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
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
    ProfilePage(), 
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
    icon: Icon(Icons.home),
    label: 'Home',
  ),

  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: 'Profile',
  ),
];
