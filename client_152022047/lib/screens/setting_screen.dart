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

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.5),
      color: AppColors.royalBlue, // Warna latar belakang Card
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user['nama_lengkap'] ?? 'Tidak ada nama',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.softBeige, // Warna teks
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person, color: AppColors.softBeige),
                SizedBox(width: 10),
                Text(
                  'NIS: ${user['nis']}',
                  style: TextStyle(fontSize: 16, color: AppColors.softBeige),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.email, color: AppColors.softBeige),
                SizedBox(width: 10),
                Text(
                  'Email: ${user['email']}',
                  style: TextStyle(fontSize: 16, color: AppColors.softBeige),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.phone, color: AppColors.softBeige),
                SizedBox(width: 10),
                Text(
                  'Nomor Telepon: ${user['nomor_telepon'] ?? 'Tidak ada'}',
                  style: TextStyle(fontSize: 16, color: AppColors.softBeige),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.home, color: AppColors.softBeige),
                SizedBox(width: 10),
                Text(
                  'Alamat: ${user['alamat'] ?? 'Tidak ada'}',
                  style: TextStyle(fontSize: 16, color: AppColors.softBeige),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.class_, color: AppColors.softBeige),
                SizedBox(width: 10),
                Text(
                  'Kelas: ${user['kelas'] ?? 'Tidak ada'}',
                  style: TextStyle(fontSize: 16, color: AppColors.softBeige),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        title: Text(
          'Settings',
          style: TextStyle(color: AppColors.softBeige), // Warna teks AppBar
        ),
        backgroundColor: AppColors.royalBlue, // Warna latar AppBar
        iconTheme:
            IconThemeData(color: AppColors.softBeige), // Warna ikon AppBar
      ),
      body: Container(
        color: AppColors.skyBlue, // Latar belakang utama
        child: Column(
          children: [
            _buildUserCard(user),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.edit, color: AppColors.softBeige),
                label: Text(
                  'Edit Profile',
                  style: TextStyle(color: AppColors.softBeige),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.royalBlue,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
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
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton.icon(
                icon: Icon(Icons.logout, color: AppColors.softBeige),
                label: Text(
                  'Logout',
                  style: TextStyle(color: AppColors.softBeige),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gingerbread, // Warna tombol logout
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
