

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/about');
              },
            ),
            ListTile(
              leading: Icon(Icons.palette),
              title: Text('Clothes'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/ClothingItem');
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Clothing Colors'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/cloth');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Shopping web'),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, '/fetchdata'); // Correct route name
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade800,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Welcome to the Home Page',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Examples:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.blue[100],
                  child: Text(
                    'Human face color can vary widely due to genetic, environmental, and lifestyle factors. Here are the primary types of human face color:',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showMore = !_showMore;
                    });
                  },
                  child: Text(_showMore ? 'See Less' : 'See More'),
                ),
                if (_showMore) ...[
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.grey[200],
                    child: Text(
                      'Additional content or more detailed information can go here.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.pink[100],
                    child: Text(
                      '2. Light\nCharacteristics: Slightly darker than fair, still light-skinned but with less proneness to sunburn.\nCommon in: People of European, Central Asian, and Middle Eastern descent.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.orange[100],
                    child: Text(
                      '3. Medium\nCharacteristics: Olive or beige skin tone, tans more easily, often with a neutral or warm undertone.\nCommon in: People of Mediterranean, Southern European, Middle Eastern, and some parts of Asia and Latin America.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.yellow[100],
                    child: Text(
                      '4. Tan\nCharacteristics: Naturally darker than medium, with a yellow or golden undertone, tans easily.\nCommon in: People of Latin American, Middle Eastern, Southeast Asian, and some Southern European descent.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.green[100],
                    child: Text(
                      '5. Brown\nCharacteristics: Deep brown skin tone, may have warm, cool, or neutral undertones, tans very easily.\nCommon in: People of South Asian, African, Caribbean, and Latin American descent.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.purple[100],
                    child: Text(
                      '6. Dark\nCharacteristics: Very deep brown to black skin tone, often with cool, warm, or neutral undertones, rarely sunburns.\nCommon in: People of African, Australian Aboriginal, and some South Asian descent.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.grey[100],
                    child: Text(
                      '7. Albino\nCharacteristics: Extremely light skin with little or no melanin, prone to sunburn, often with reddish or pink undertones due to visible blood vessels.\nCommon in: People with albinism, a genetic condition affecting melanin production.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
