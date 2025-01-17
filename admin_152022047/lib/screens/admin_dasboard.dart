import 'package:admin_152022047/api/local_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:admin_152022047/auth/login_screen.dart';
import 'package:admin_152022047/screens/Admin_Chat_List_Page.dart';
import 'package:admin_152022047/screens/kalender_akademik_admin.dart';
import 'package:admin_152022047/screens/kelola_user_page.dart';
import 'package:admin_152022047/screens/show_all_table.dart';
import 'package:admin_152022047/screens/soal_bos_admin_page.dart';
import 'package:admin_152022047/screens/grafik_kelas_siswa.dart';
import 'package:admin_152022047/styles.dart';


class AdminDashboard extends StatelessWidget {
  Future<void> _showAllTables(BuildContext context) async {
    try {
      final url = "${LocalApi.baseUrl}/all-tables";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('No Tables Found'),
              content: Text('Database does not contain any tables.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowAllTablesPage(tableData: data),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Failed to fetch data. Status code: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(color: AppColors.softBeige), // Warna teks AppBar
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme:
            IconThemeData(color: AppColors.softBeige), // Warna ikon di AppBar
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.royalBlue, // Warna latar DrawerHeader
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
              leading: Icon(Icons.table_chart),
              title: Text('Lihat Semua Tabel Dalam Database'),
              onTap: () => _showAllTables(context),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Lihat Grafik Kelas Siswa'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GrafikKelasSiswa()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: AppColors.skyBlue, // Latar belakang skyBlue
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildDashboardButton(
              context,
              icon: Icons.people,
              label: 'Manage Siswa',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KelolaUserPage()),
                );
              },
            ),
            _buildDashboardButton(
              context,
              icon: Icons.calendar_today,
              label: 'Manage Kalender Akademik',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KalenderAkademikAdminPage()),
                );
              },
            ),
            _buildDashboardButton(
              context,
              icon: Icons.book,
              label: 'Manage Soal / Buku BOS',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SoalBOSAdminPage()),
                );
              },
            ),
            _buildDashboardButton(
              context,
              icon: Icons.chat,
              label: 'Manage Chats',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AdminChatListPage(adminUsername: 'adminUsername')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.powderBlue, // Warna tombol powderBlue
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.royalBlue),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.royalBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
