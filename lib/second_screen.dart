// second_screen.dart
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Screen')),
      body: ListView(
        children: const <Widget>[
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Map'),
          ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Album'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Back'),
          ),
        ],
      ),

      // Center(
      //   child: ElevatedButton(
      //     child: Text('Go Back'),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
    );
  }
}
