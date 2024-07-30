import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
              title: Text('clothes'),
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
            // New ListTile for ClothingColorRecommender
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Clothing Colors'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/cloth');
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              Expanded(
  child: ListView(
    children: [
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.blue[100],
        child: Text(
          'Human face color can vary widely due to genetic, environmental, and lifestyle factors. Here are the primary types of human face color:',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.red[100],
        child: Text(
          '1. Fair\nCharacteristics: Light complexion, prone to sunburn, usually with a reddish or pink undertone.\nCommon in: People of Northern European descent.',
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
  ),
),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print('See More pressed');
                  },
                  child: Text('See More'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
            BottomNavigationBarItem(
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white),
              ),
              label: '',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

