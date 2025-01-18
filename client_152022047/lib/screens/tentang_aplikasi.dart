import 'package:flutter/material.dart';
import 'package:client_152022047/styles.dart';

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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Membuat gambar menjadi rounded
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          75), // Radius 50% dari ukuran gambar
                      child: Image.asset(
                        'assets/image/Logo_Client.png', // Replace with your app logo asset
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Aplikasi EduZone',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.royalBlue, // RoyalBlue
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Aplikasi EduZone versi siswa dirancang untuk mendukung kebutuhan akademik dan kegiatan harian siswa secara digital. Aplikasi ini dilengkapi dengan fitur zonasi, yang memungkinkan siswa menghitung jarak rumah ke SMA impian menggunakan Google Maps. Selain itu, terdapat fitur jadwal sholat harian yang membantu siswa menjalankan ibadah tepat waktu. Siswa juga dapat mencatat tugas atau kegiatan penting melalui aplikasi notes, lengkap dengan pengaturan tanggal deadline untuk mengingatkan tugas yang harus diselesaikan. Fitur lainnya mencakup akses ke daftar soal dan buku BOS, kalender akademik, dan kalender libur tahunan yang berisi informasi tanggal-tanggal penting. Untuk komunikasi, siswa dapat menggunakan fitur chat untuk menyampaikan keluhan atau pertanyaan kepada admin. Aplikasi ini juga memungkinkan siswa memperbarui profil dan kata sandi mereka, menjadikannya alat yang lengkap untuk mendukung kebutuhan akademik dan personal siswa.',
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
      ),
    );
  }
}
