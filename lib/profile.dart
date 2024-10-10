import 'package:bus_reservation_system/components/card.dart';
import 'package:flutter/material.dart';
import 'package:bus_reservation_system/model/trip_json_model.dart';
import  'package:http/http.dart' as http;
import 'package:bus_reservation_system/model/globals.dart' as global;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:bus_reservation_system/main.dart';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final String fullname = '${global.name!.first_name} ${global.name!.last_name}';
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Avatar and Name
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green,
              child: Text(
                fullname[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              fullname ,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Profile Menu Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'PROFILE MENU',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    
                    ListTile(
                      
                      leading: Icon(Icons.directions_bus, color: Colors.black),
                      title: Text('Past Bus Trips'),
                      onTap: (){
                        
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PastBusTripsPage()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle, color: Colors.black),
                      title: Text('Change Password'),
                      onTap: (){
Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingsPage()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.confirmation_number, color: Colors.black),
                      title: Text('Reserved Trips'),
                      onTap: (){
Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ReservedTripsPage()));
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // Logout Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.grey[300], // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
              ),
              onPressed: () {
                Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
              },
              child: Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
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
// Dummy pages for navigation
class PastBusTripsPage extends StatelessWidget {


Future<List<Trip>> loadPastTrips() async{
  String url = 'https://bus-reservation-system-api.vercel.app/ticket/search?role=${global.role}&user_id=${global.user_id}&filter=past bus trip';

  final response = await http.get(Uri.parse(url));
  if(response.statusCode == 200){
    final List<dynamic> data = json.decode(response.body);
    List<Trip> pastTrips = data.map((json)=> Trip.fromJson(json)).toList();

    return pastTrips;
  }else{
    
    return [];
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Bus Trips'),
      ),
      body: SingleChildScrollView(
        child:  FutureBuilder<List<Trip>?>(
          future: loadPastTrips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            
            return Center(child: Text('No Trip Found'));
          } else {
            final data = snapshot.data;
            return ListView.builder(
              shrinkWrap: true, // Set to true to avoid infinite height issue
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
               return TripCard(pickupLocation: data![index].route!.origin!, destination: data[index].route!.destination!, arrival: DateFormat('MMMM d, yyyy').format(convertToDateTime(
                            data[index].route!.tripDate!.seconds!,
                            data[index].route!.tripDate!.nanoseconds!)), departure: DateFormat('h:mma').format(convertToDateTime(
                            data[index].route!.tripDate!.seconds!,
                            data[index].route!.tripDate!.nanoseconds!)));
                }
            );
          }
        }
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget{
  @override
  State<SettingsPage> createState() => SettingsPageState();
}
class SettingsPageState extends State<SettingsPage> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final Map<String, bool> _passwordVisibility = {
    'old' : true,
    'new' : true,
    'confirm' : true
  };
  bool _isButtonDisabled = false;

  Future<void> _changePassword() async {
    setState(() {
      _isButtonDisabled = true;
    });

    // Simulate a network request or some async operation
    final url = 'https://bus-reservation-system-api.vercel.app/users/passenger/changepassword';
    final response = await http.post(Uri.parse(url),
    headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': global.username,
          'password': _oldPassword.text,
          'newPassword' : _newPassword.text,
          'confirmPassword' : _confirmPassword.text 
        }),
    );
var data = jsonDecode(response.body);
    if(response.statusCode == 200){
ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password changed successfully'),backgroundColor: Colors.green,),
      
    );
    }else{
ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${data['message']}'),
          backgroundColor: Colors.red,
        ),
      );
    }
    // Re-enable the button after the operation is successful
    setState(() {
      _isButtonDisabled = false;
    });

    // Show a success message or perform other actions
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        TextField(
          controller: _oldPassword,
          decoration: InputDecoration(
            labelText: 'Old Password',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
                    icon: Icon(_passwordVisibility['old']!
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _passwordVisibility['old'] =! _passwordVisibility['old']!;
                      });
                    },
                  )
          ),
          obscureText: _passwordVisibility['old']!,
        ),const SizedBox(height: 20),
        TextField(
          controller: _newPassword,
          decoration: InputDecoration(
            labelText: 'New Password',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
                    icon: Icon(_passwordVisibility['new']!
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _passwordVisibility['new'] =! _passwordVisibility['new']!;
                      });
                    },
                  )
          ),
          obscureText: _passwordVisibility['new']!,
        ),
        const SizedBox(height: 20),
       TextField(
          controller: _confirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
                    icon: Icon(_passwordVisibility['confirm']!
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _passwordVisibility['confirm'] =! _passwordVisibility['confirm']!;
                      });
                    },
                  )
          ),
          obscureText: _passwordVisibility['confirm']!,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isButtonDisabled ? null : _changePassword,
          child: Text('Change Password'),
        ),
          ],
        ),
      ),
      
    );
  }
}

class ReservedTripsPage extends StatelessWidget {
  

Future<List<Trip>> loadPastTrips() async{
  String url = 'https://bus-reservation-system-api.vercel.app/ticket/search?role=${global.role}&user_id=${global.user_id}&filter=reserved trip';
  final response = await http.get(Uri.parse(url));
  if(response.statusCode == 200){
    final List<dynamic> data = json.decode(response.body);
    List<Trip> pastTrips = data.map((json)=> Trip.fromJson(json)).toList();

    return pastTrips;
  }else{
    
    return [];
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserved Trips'),
      ),
      body: SingleChildScrollView(
        child:  FutureBuilder<List<Trip>?>(
          future: loadPastTrips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            
            return Center(child: Text('No Trip Found'));
          } else {
            final data = snapshot.data;
            return ListView.builder(
              shrinkWrap: true, // Set to true to avoid infinite height issue
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
               return TripCard(pickupLocation: data![index].route!.origin!, destination: data[index].route!.destination!, arrival: DateFormat('MMMM d, yyyy').format(convertToDateTime(
                            data[index].route!.tripDate!.seconds!,
                            data[index].route!.tripDate!.nanoseconds!)), departure: DateFormat('h:mma').format(convertToDateTime(
                            data[index].route!.tripDate!.seconds!,
                            data[index].route!.tripDate!.nanoseconds!)));
                }
            );
          }
        }
        ),
      ),
    );
  }
}
