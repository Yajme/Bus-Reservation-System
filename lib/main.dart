import 'package:bus_reservation_system/login.dart';
import 'package:flutter/material.dart';
import 'package:bus_reservation_system/home.dart';
import 'package:bus_reservation_system/tickets.dart';
import 'package:bus_reservation_system/profile.dart';
import 'package:provider/provider.dart';
/*
Colors: 3DCAA0
F5F5F5
cfe6e6
 */
void main() {
  runApp(ChangeNotifierProvider(
    create: (context)=>TabIndex(),
    child: const MainApp()
    ));
}
class TabIndex with ChangeNotifier{
  int _index = 0;
  int get index => _index;

  void changeIndex(int i){
    _index = i;
    notifyListeners();
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  //CurrentIndex of page
  //int _selectedIndex = 0;

 

  @override
  void initState() {
    super.initState();

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
        home: Login());
  }
}
class Passenger extends StatefulWidget{

  @override
  State<Passenger> createState() => PassengerState();
}

class PassengerState extends State<Passenger>{


@override
  Widget build(BuildContext context) {
    final _selectedIndex = Provider.of<TabIndex>(context)._index;
    return Scaffold(
           resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: bottomNavBarItems,
              currentIndex: _selectedIndex,
              onTap: (index){
                Provider.of<TabIndex>(context,listen: false).changeIndex(index);
              },
            )
            );
  }
}
 // List of pages to display
  final List<Widget> _pages=[
      Home(),
      TicketList(),
      ProfilePage(), //<- Replace with Profile Page
    ];

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


class Login extends StatelessWidget {
  const Login ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

          return Center(
            child: isSmallScreen
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //_Logo(),
                      LoginScreen(), // Use the LoginScreen widget here
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: [
                        //const Expanded(child: _Logo()),
                        Expanded(
                          child: Center(
                              child:
                                  LoginScreen()), // Use the LoginScreen widget here
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}