import 'package:client_152022047/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:client_152022047/styles.dart';
import 'edit_profile_page.dart';

class SettingScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  SettingScreen({required this.user});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        title: Text(
          'Profile',
          style: TextStyle(color: AppColors.softBeige), // Warna teks AppBar
        ),
        backgroundColor: AppColors.royalBlue, // Warna latar AppBar
        iconTheme:
            IconThemeData(color: AppColors.softBeige), // Warna ikon AppBar
      ),
      body: Container(
        color: AppColors.skyBlue, // Latar belakang utama
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Profil
            Container(
              padding: const EdgeInsets.all(16.0),
              color: AppColors.skyBlue,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        AppColors.powderBlue, // Warna latar belakang
                    child: Icon(
                      Icons.person, // Icon user default
                      size: 50,
                      color: AppColors.royalBlue, // Warna icon
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    user['nama_lengkap'] ?? 'Tidak ada nama',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.royalBlue,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user['email'] ?? 'Tidak ada email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'NIS: ${user['nis']?.toString() ?? 'Tidak ada NIS'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[500]),

            // Section 2: Informasi Detail
            Expanded(
              child: Container(
                color: AppColors.skyBlue,
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person, color: AppColors.royalBlue),
                      title: Text(
                        'Nama Lengkap',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user['nama_lengkap'] ?? 'Tidak ada nama'),
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.grey[500]),
                    ListTile(
                      leading: Icon(Icons.badge, color: AppColors.royalBlue),
                      title: Text(
                        'NIS',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text(user['nis']?.toString() ?? 'Tidak ada NIS'),
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.grey[500]),
                    ListTile(
                      leading: Icon(Icons.class_, color: AppColors.royalBlue),
                      title: Text(
                        'Kelas',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user['kelas'] ?? 'Tidak ada kelas'),
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.grey[500]),
                    ListTile(
                      leading: Icon(Icons.home, color: AppColors.royalBlue),
                      title: Text(
                        'Alamat',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user['alamat'] ?? 'Tidak ada alamat'),
                    ),
                    Divider(height: 1, thickness: 1, color: Colors.grey[500]),
                  ],
                ),
              ),
            ),

            // Section 3: Tombol di bagian paling bawah
            Container(
              color: AppColors.skyBlue,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.edit, color: AppColors.softBeige),
                    label: Text(
                      'Edit Profile',
                      style: TextStyle(color: AppColors.softBeige),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.powderBlue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            nis: user['nis'],
                            user: {},
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: Icon(Icons.logout, color: AppColors.softBeige),
                    label: Text(
                      'Logout',
                      style: TextStyle(color: AppColors.softBeige),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gingerbread,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _logout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
