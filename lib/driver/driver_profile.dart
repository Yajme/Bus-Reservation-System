import 'package:flutter/material.dart';

//TODO : Create a profile page for user


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                'J',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'John Doe',
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
                    ),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.black),
                      title: Text('Settings'),
                    ),
                    ListTile(
                      leading: Icon(Icons.confirmation_number, color: Colors.black),
                      title: Text('Reserved Trips'),
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
                // Add logout functionality
              },
              child: Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}

