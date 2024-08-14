import 'package:flutter/material.dart';
import 'second_screen.dart'; // Import the second screen class
import 'home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform login logic
      String username = _usernameController.text;
      String password = _passwordController.text;
      // Implement your login logic here
      print('Username: $username, Password: $password');

      loginUser();
    }
  }

  void loginUser() async {
    final url = Uri.parse('https://dummyjson.com/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': 'emilys',
        'password': 'emilyspass',
        'expiresInMins': 30, // optional, defaults to 60
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);

      Navigator.push(
        context,
        //MaterialPageRoute(builder: (context) => SecondScreen()),
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print('Failed to login: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    final List<Widget> aboutBoxChildren = <Widget>[
      const SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text: "Flutter is Google's UI toolkit for building beautiful, "
                    'natively compiled applications for mobile, web, and desktop '
                    'from a single codebase. Learn more about Flutter at '),
            TextSpan(
                style: textStyle.copyWith(color: theme.colorScheme.primary),
                text: 'https://flutter.dev'),
            TextSpan(style: textStyle, text: '.'),
          ],
        ),
      ),
    ];

    return Scaffold(

      // appBar: AppBar(
      //     //title: Text('Login Page'),
      //     ),
      body: Center( child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(
                'https://plus.unsplash.com/premium_vector-1683141338125-daf778a0e85e?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                // Replace with your image URL
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('OR login with'),
              SizedBox(height: 20),
              SizedBox(height: 20),

              ElevatedButton(
                child: const Text('Show About Example'),
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationIcon: const FlutterLogo(),
                    applicationName: 'Show About Example',
                    applicationVersion: 'August 2019',
                    applicationLegalese: '\u{a9} 2014 The Flutter Authors',
                    children: aboutBoxChildren,
                  );
                },
              )
            ],
          ),
        ),
      ))),
    );
  }
}
