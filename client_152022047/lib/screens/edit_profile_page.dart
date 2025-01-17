import 'dart:convert';
import 'package:client_152022047/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:client_152022047/api/local_api.dart';

class EditProfilePage extends StatefulWidget {
  final int nis; // ID user yang akan diedit

  EditProfilePage({required this.nis, required Map<String, dynamic> user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // Fetch user details
  Future<void> _fetchUserDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('${LocalApi.baseUrl}/api/users/${widget.nis}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        setState(() {
          nameController.text = user['nama_lengkap'] ?? '';
          emailController.text = user['email'] ?? '';
          phoneController.text = user['nomor_telepon'] ?? '';
          addressController.text = user['alamat'] ?? '';
        });
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user details: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Update user details
  Future<void> _updateUserDetails() async {
    final url = Uri.parse('${LocalApi.baseUrl}/api/users/${widget.nis}');
    final updatedData = {
      'nama_lengkap': nameController.text,
      'email': emailController.text,
      'nomor_telepon': phoneController.text,
      'alamat': addressController.text,
    };

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context, true); // Return success
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme:
            IconThemeData(color: AppColors.softBeige),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Nomor Telepon',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateUserDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.powderBlue, // Warna tombol
                        foregroundColor: AppColors.royalBlue, // Warna teks
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0,
                        ),
                      ),
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
