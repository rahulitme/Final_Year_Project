import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Main Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: Text('Go to Home Page'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
          
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              child: Text('Go to About Page'),
              style: ElevatedButton.styleFrom(
               backgroundColor: Colors.green,
                
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cloth');
              },
              child: Text('Go to Clothing Colors'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
            
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
              SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/clothes');
              },
              child: Text('Ecommerce'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
            
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
               SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Ecommerce'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
            
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}