import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FetchDataPage extends StatelessWidget {
  // Function to open the URL
  Future<void> _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Websites'),
        backgroundColor: Colors.teal, // Changed AppBar color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, '/home'); // Navigate back to home
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Visit Your Favorite Shopping Sites',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              _buildShoppingButton(
                  'Go to Flipkart', 'https://www.flipkart.com', Colors.orange),
              SizedBox(height: 20),
              _buildShoppingButton(
                  'Go to Amazon', 'https://www.amazon.in', Colors.blue),
              SizedBox(height: 20),
              _buildShoppingButton(
                  'Go to Shopify', 'https://www.shopify.com', Colors.green),
              SizedBox(height: 20),
              _buildShoppingButton('Go to ShopClues',
                  'https://www.shopclues.com', Colors.purple),
              SizedBox(height: 40),
              // Back to Home button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(
                      context); // Pop the current screen off the stack and go back to the previous screen
                },
                icon: Icon(Icons.home),
                label: Text('Back to Home'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build styled buttons
  Widget _buildShoppingButton(String text, String url, Color color) {
    return ElevatedButton(
      onPressed: () {
        _launchUrl(url);
      },
      child: Text(text, style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        backgroundColor: color,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
      ),
    );
  }
}
