import 'dart:convert';
import 'package:client_152022047/api/local_api.dart';
import 'package:client_152022047/auth/register_screen.dart';
import 'package:client_152022047/screens/client_dasboard.dart';
import 'package:client_152022047/screens/tentang_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client_152022047/styles.dart';
import 'package:url_launcher/url_launcher.dart'; // Import untuk membuka link

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = "${LocalApi.baseUrl}/api/user/login";
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'identifier': identifier, // Bisa email atau NIS
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ClientDashboard(user: data['data']),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Login failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final Uri _videoDemoUrl = Uri.parse(
      'https://www.youtube.com/watch?v=dQw4w9WgXcQ'); // Ganti link sesuai kebutuhan

  Future<void> _openVideoDemo() async {
    if (!await launchUrl(_videoDemoUrl)) {
      throw Exception('Could not launch $_videoDemoUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.skyBlue, // SkyBlue background
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 70),
                    Image.asset(
                      'assets/image/login_user.png',
                      height: 150,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.royalBlue, // RoyalBlue
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please log in to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: _identifierController,
                      decoration: InputDecoration(
                        labelText: 'Email or NIS',
                        hintText: 'Enter your email or NIS',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.powderBlue, // PowderBlue
                              padding: EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Don't have an account? Register here.",
                        style: TextStyle(
                          color: AppColors.royalBlue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TentangAplikasiScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.royalBlue, // RoyalBlue
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Tentang Aplikasi',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _openVideoDemo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.royalBlue, // RoyalBlue
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Video Demo',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
