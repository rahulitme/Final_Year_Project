import 'package:flutter/material.dart';
import 'boy_page.dart';
import 'girl_page.dart';

class SimplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Page'),
      ),
      body: Row(
        children: <Widget>[
          // Left Frame
          Expanded(
            child: Container(
              color: Colors.blue[50], // Optional: Add a background color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('This is the Simple Page'),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BoyPage()),
                        );
                      },
                      icon: Icon(Icons.boy), // Boy icon
                      label: Text('Go to Boy Page'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right Frame
          Expanded(
            child: Container(
              color: Colors.green[50], // Optional: Add a background color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('This is the Simple Page'),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GirlPage()),
                        );
                      },
                      icon: Icon(Icons.girl), // Girl icon
                      label: Text('Go to Girl Page'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
