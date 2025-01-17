import 'package:flutter/material.dart';
import 'package:admin_152022047/styles.dart'; // Import file AppColors

class TentangAplikasiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.skyBlue, // Background color same as LoginScreen
      appBar: AppBar(
        title: Text(
          'Tentang Aplikasi',
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme: IconThemeData(color: AppColors.softBeige),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/image/Logo_Admin.png', // Replace with your app logo asset
                    height: 150,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aplikasi EduZone Versi Admin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.royalBlue, // RoyalBlue
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aplikasi EduZone versi admin dirancang untuk mempermudah pengelolaan administrasi sekolah secara digital. Admin memiliki akses untuk mengelola data siswa, termasuk menambah, mengedit, membaca, dan menghapus informasi siswa. Selain itu, admin dapat mengatur kalender akademik serta soal dan buku BOS dengan fitur CRUD yang lengkap. Untuk mendukung komunikasi, aplikasi ini menyediakan fitur chat langsung antara admin dan siswa, sehingga memudahkan penanganan keluhan atau pertanyaan. Admin juga dapat melihat seluruh tabel database untuk pemantauan data yang lebih terstruktur, serta memantau grafik distribusi siswa berdasarkan kelas dan jumlah siswa aktif di sekolah. Fitur-fitur ini membuat pengelolaan sekolah menjadi lebih efisien dan terorganisir.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
