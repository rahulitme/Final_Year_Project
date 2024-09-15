// splex.dart

import 'package:flutter/material.dart';

class SplexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splex Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png', // Replace with your asset path
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Splex Page!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Navigate to Home Page
              },
              child: Text('Go to Home Page'),
            ),
          ],
        ),
      ),
    );
  }
}
