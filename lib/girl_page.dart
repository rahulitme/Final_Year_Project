import 'package:flutter/material.dart';

class GirlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Girl Page'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.pink[100], // Background color
            child: Center(
              child: Text(
                'Girls Image',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Color.fromARGB(255, 143, 242, 244), // Background color
            child: Center(
              child: Image.asset(
                'images/girl1.jpg',
                width: 150,
                height: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
