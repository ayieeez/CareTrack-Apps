import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'nearbyclinic_page.dart';
import 'profile_page.dart';
import 'landing_page.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for launching URLs

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _storage = FlutterSecureStorage();
  String _username = '';
  int _currentIndex = 2; // Set current index to About Page

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    String? token = await _storage.read(key: 'token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _username = data['name'];
        });
      } else {
        setState(() {
          _username = 'Error fetching name';
        });
      }
    } else {
      setState(() {
        _username = 'No token found';
      });
    }
  }

  // Function to handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the respective page based on the index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()), // Home
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NearbyClinicPage()), // Nearby Clinic
        );
        break;
      case 2:
        // Stay on AboutPage
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()), // Profile
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 120,
          child: Image.asset(
            'assets/whitelogo.png',
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Team Members Section
              Text(
                'Team Members',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildMemberCard(
                  'Muhammad Izzudin bin Zuraimi',
                  'Project Manager',
                  'muhammadizzuddin4600@gmail.com',
                  'assets/member1.jpg'),
              _buildMemberCard(
                  'Muhammad Norhashim bin Mohamed',
                  'Lead Development',
                  'chaimsmoker02@gmail.com',
                  'assets/member2.png'),
              _buildMemberCard(
                  'Hazim bin Md. Yusof',
                  'Project Designer',
                  'azimyusof54@gmail.com',
                  'assets/member3.jpg'),
              _buildMemberCard(
                  'Ahmad Fahim bin Alilah',
                  'UI/UX Designer',
                  'fahimalilah0@gmail.com',
                  'assets/member4.jpg'),
              _buildMemberCard(
                  'Wan Nur Athirah binti Wan Azmi',
                  'Backend Developer',
                  'athirahkylez@gmail.com',
                  'assets/member5.jpg'),
              SizedBox(height: 20),

              // Information Section
              Text(
                'Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'This application serves to display users nearest hospital or health clinic with markers.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Copyright Section
              Text(
                'Copyright Statement',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '© 2025 Caretrack. All rights reserved.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Website Section
              Text(
                'Website',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'For more information, visit our ',
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () async {
                  final Uri url = Uri.parse('https://github.com/addff/2410-ICT602/tree/main/Group%20Project/TEAM%20B%20001');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  'GitHub page.',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Nearest Clinic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildMemberCard(String name, String qualification, String email, String imagePath) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(qualification),
                  SizedBox(height: 5),
                  Text(email, style: TextStyle(color: Colors.grey)), // Display email
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}