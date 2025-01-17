import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:admin_152022047/styles.dart'; // Import styles.dart
import 'package:admin_152022047/api/local_api.dart'; // Import LocalApi

class KelolaUserPage extends StatefulWidget {
  @override
  _KelolaUserPageState createState() => _KelolaUserPageState();
}

class _KelolaUserPageState extends State<KelolaUserPage> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('${LocalApi.baseUrl}/table/users');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          users = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        throw Exception('Failed to fetch users');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _createUser(Map<String, dynamic> userData) async {
    final url = Uri.parse('${LocalApi.baseUrl}/api/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    return response.statusCode == 201;
  }

  Future<bool> _updateUser(int nis, Map<String, dynamic> userData) async {
    final url = Uri.parse('${LocalApi.baseUrl}/api/users/$nis');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    return response.statusCode == 200;
  }

  Future<void> _deleteUser(int nis) async {
    final url = Uri.parse('${LocalApi.baseUrl}/api/users/$nis');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
      _fetchUsers(); // Refresh list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user')),
      );
    }
  }

  void _showForm({Map<String, dynamic>? user}) {
    final TextEditingController nisController =
        TextEditingController(text: user != null ? user['nis'].toString() : '');
    final TextEditingController nameController =
        TextEditingController(text: user != null ? user['nama_lengkap'] : '');
    final TextEditingController emailController =
        TextEditingController(text: user != null ? user['email'] : '');
    final TextEditingController phoneController =
        TextEditingController(text: user != null ? user['nomor_telepon'] : '');
    final TextEditingController addressController =
        TextEditingController(text: user != null ? user['alamat'] : '');
    final TextEditingController passwordController = TextEditingController();

    String? selectedClass = user != null ? user['kelas'] : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.skyBlue, // Warna latar belakang dialog
          title: Text(
            user == null ? 'Create User' : 'Edit User',
            style: TextStyle(
              color: AppColors.royalBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nisController,
                  decoration: InputDecoration(
                    labelText: 'NIS',
                    labelStyle: TextStyle(color: AppColors.royalBlue),
                    filled: true,
                    fillColor: AppColors.powderBlue, // Warna latar TextField
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.royalBlue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.softBeige),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    labelStyle: TextStyle(color: AppColors.royalBlue),
                    filled: true,
                    fillColor: AppColors.powderBlue,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.royalBlue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.softBeige),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.royalBlue),
                    filled: true,
                    fillColor: AppColors.powderBlue,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.royalBlue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.softBeige),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    labelStyle: TextStyle(color: AppColors.royalBlue),
                    filled: true,
                    fillColor: AppColors.powderBlue,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.royalBlue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.softBeige),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    labelStyle: TextStyle(color: AppColors.royalBlue),
                    filled: true,
                    fillColor: AppColors.powderBlue,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.royalBlue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.softBeige),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppColors.royalBlue),
                    filled: true,
                    fillColor: AppColors.powderBlue,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.royalBlue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.softBeige),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedClass,
                  decoration: InputDecoration(
                    labelText: 'Kelas',
                    labelStyle: TextStyle(color: AppColors.royalBlue),
                    filled: true,
                    fillColor: AppColors.powderBlue, // Warna latar dropdown
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.royalBlue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.softBeige),
                    ),
                  ),
                  items: ['7', '8', '9']
                      .map((kelas) => DropdownMenuItem<String>(
                            value: kelas,
                            child: Text(
                              'Kelas $kelas',
                              style: TextStyle(color: AppColors.royalBlue),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedClass = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.royalBlue),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.powderBlue,
              ),
              onPressed: () async {
                final newUser = {
                  'nis': int.tryParse(nisController.text),
                  'nama_lengkap': nameController.text,
                  'email': emailController.text,
                  'password': passwordController.text.isNotEmpty
                      ? passwordController.text
                      : user != null
                          ? null
                          : 'password123', // Default password
                  'nomor_telepon': phoneController.text,
                  'alamat': addressController.text,
                  'kelas': selectedClass,
                };

                if (user == null) {
                  final success = await _createUser(newUser);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(success
                        ? 'User created successfully'
                        : 'Failed to create user'),
                  ));
                } else {
                  final success = await _updateUser(user['nis'], newUser);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(success
                        ? 'User updated successfully'
                        : 'Failed to update user'),
                  ));
                }

                Navigator.pop(context);
                _fetchUsers();
              },
              child: Text(
                user == null ? 'Create' : 'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kelola Users',
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme: IconThemeData(color: AppColors.softBeige),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add, color: AppColors.softBeige),
        //     onPressed: () => _showForm(), // Membuka form untuk tambah user baru
        //   ),
        // ],
      ),
      body: Container(
        color: AppColors.skyBlue,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : users.isEmpty
                ? Center(child: Text('No users available'))
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        color: AppColors.powderBlue,
                        child: ListTile(
                          title: Text(
                            user['nama_lengkap'],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            user['email'],
                            style: TextStyle(color: Colors.white70),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: AppColors.royalBlue),
                                onPressed: () => _showForm(user: user),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: AppColors.gingerbread),
                                onPressed: () => _deleteUser(user['nis']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(), // Membuka form untuk tambah user baru
        backgroundColor: AppColors.royalBlue,
        child: Icon(Icons.add, color: AppColors.softBeige),
      ),
    );
  }
}
