import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'nearbyclinic_page.dart';
import 'about_page.dart';
import 'landing_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _storage = FlutterSecureStorage();
  String _name = '';
  String _email = '';
  String? _profileImagePath;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
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
          _name = data['name'];
          _email = data['email'];
          _nameController.text = _name; // Set initial value for name
        });
      } else {
        _handleError(response);
      }
    }
  }

  void _updateProfile() async {
    String? token = await _storage.read(key: 'token');
    if (token != null) {
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/user/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'email': _email, // Include email in the request body
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        _handleError(response);
      }
    }
  }

  void _changePassword() async {
    String? token = await _storage.read(key: 'token');
    if (token != null) {
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/user/change-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'current_password': _currentPasswordController.text,
          'new_password': _newPasswordController.text,
          'new_password_confirmation': _confirmPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully!')),
        );
        // Clear the password fields after successful change
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } else {
        _handleError(response);
      }
    }
  }

  void _handleError(http.Response response) {
    String errorMessage;
    if (response.statusCode == 403) {
      errorMessage = 'Access denied. Please check your credentials.';
    } else if (response.statusCode == 404) {
      errorMessage = 'Endpoint not found. Please check the URL.';
    } else if (response.statusCode == 422) {
      var errorData = jsonDecode(response.body);
      errorMessage = errorData['message'] ?? 'Validation error occurred.';
    } else {
      errorMessage = 'Error: ${response.statusCode} - ${response.body}';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
      // You can implement the image upload logic here if needed
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NearbyClinicPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AboutPage()),
        );
        break;
      case 3:
        // Already on Profile page, do nothing
        break;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImagePath != null
                    ? FileImage(File(_profileImagePath!))
                    : AssetImage('assets/default_profile.png') as ImageProvider,
                child: _profileImagePath == null
                    ? Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      title: Text('Name'),
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                        ),
                        controller: _nameController,
                      ),
                    ),
                    ListTile(
                      title: Text('Email'),
                      subtitle: Text(_email),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: Text('Update Profile'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      title: Text('Current Password'),
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter current password',
                        ),
                        obscureText: true,
                        controller: _currentPasswordController,
                      ),
                    ),
                    ListTile(
                      title: Text('New Password'),
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter new password',
                        ),
                        obscureText: true,
                        controller: _newPasswordController,
                      ),
                    ),
                    ListTile(
                      title: Text('Confirm New Password'),
                      subtitle: TextField(
                        decoration: InputDecoration(
                          hintText: 'Confirm new password',
                        ),
                        obscureText: true,
                        controller: _confirmPasswordController,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_newPasswordController.text == _confirmPasswordController.text) {
                          _changePassword();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Passwords do not match.')),
                          );
                        }
                      },
                      child: Text('Change Password'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
}