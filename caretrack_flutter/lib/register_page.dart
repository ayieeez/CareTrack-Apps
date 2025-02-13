import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart'; // Import the LoginPage

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _passwordConfirmation = '';
  bool _obscurePassword = true; // To toggle password visibility
  bool _obscurePasswordConfirmation =
      true; // To toggle confirmation password visibility

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/register'), // Use your local IP
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': _name,
          'email': _email,
          'password': _password,
          'password_confirmation': _passwordConfirmation,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pop(
            context); // Go back to login after successful registration
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registration failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo section
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 20),
                  child: Image.asset(
                    'assets/logo.png', // Update with your logo path
                    height: 160, // Adjust height as needed
                  ),
                ),

                // Header section
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Fill in the details to register',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Form section
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name TextField
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please enter your name'
                              : null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      // Email TextField
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please enter an email'
                              : null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      // Password TextField
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                          suffixIcon: GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _obscurePassword = false; // Show password
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _obscurePassword = true; // Hide password
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please enter a password'
                              : null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      // Confirm Password TextField
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[200],
                          suffixIcon: GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _obscurePasswordConfirmation =
                                    false; // Show confirmation password
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _obscurePasswordConfirmation =
                                    true; // Hide confirmation password
                              });
                            },
                            child: Icon(
                              _obscurePasswordConfirmation
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        obscureText: _obscurePasswordConfirmation,
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please confirm your password'
                              : null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _passwordConfirmation = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent, // Button color
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white, // Change text color to white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer section for login prompt
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
