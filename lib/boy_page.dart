import 'package:flutter/material.dart';
import 'ai_service.dart'; // Import the AIService class

class BoyPage extends StatefulWidget {
  @override
  _BoyPageState createState() => _BoyPageState();
}

class _BoyPageState extends State<BoyPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';

  void _getAIResponse() async {
    try {
      final response = await AIService.getResponse(_controller.text);
      setState(() {
        _response = response;
      });
    } catch (e) {
      setState(() {
        _response = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boy Page'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[100], // Background color
            child: Center(
              child: Text(
                'Boys Image',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[200], // Background color
            child: Center(
              child: Image.asset(
                'images/photo.jpeg',
                width: 150,
                height: 150,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your prompt',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _getAIResponse,
            child: Text('Get AI Response'),
          ),
          SizedBox(height: 20),
          Text(
            _response,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
