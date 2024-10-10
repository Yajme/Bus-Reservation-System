import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bus_reservation_system/model/globals.dart' as global;
import 'dart:convert';
import 'package:bus_reservation_system/main.dart';
import 'package:bus_reservation_system/register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String baseURL = 'https://bus-reservation-system-api.vercel.app';
  Future<void> authenticate(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/users/passenger'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['message'] == 'Authorized') {
          await setGlobals(data['id'],data['role'],username);
          
        } else {
          _showErrorDialog(data['message'] ?? 'Unknown error');
        }
      } else {
        _showErrorDialog('Failed to login. Please try again.');
      }
    } catch (e) {
      print('Error occurred: $e');
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  Future<void> setGlobals(String id, String role,String username) async{
    global.user_id = id;
    global.role = role;
    global.username = username;
    try{
      final response = await http.get(Uri.parse('$baseURL/users/passenger?id=$id&role=$role'));
      var data = Map<String, String>.from(jsonDecode(response.body));
      if(response.statusCode == 200){
        global.passenger_id = data['id']!;
        global.name = global.Name.fromMap(data);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  Passenger()),
          );
          
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${data['message']}'),
          backgroundColor: Colors.red,
        ),
      );
      }
    }catch(e){
      print('Error occurred: $e');
      _showErrorDialog('An error occurred. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invalid email or password'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your Username',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
          
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  backgroundColor: const Color(0xff108494),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    authenticate(emailController.text, passwordController.text);
                  }
                },
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text(
                'Sign up',
                style: TextStyle(
                  color: Color(0xff108494),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}