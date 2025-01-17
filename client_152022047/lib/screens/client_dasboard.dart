import 'package:client_152022047/styles.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'google_map_page.dart';
import 'jadwal_sholat_page.dart';
import 'notes_page.dart';
import 'soal_bos_client_page.dart';
import 'dayoff_calendar_page.dart';
import 'kalender_akademik_client.dart';
import 'chat_page.dart';
import 'setting_screen.dart';

class ClientDashboard extends StatefulWidget {
  final Map<String, dynamic> user;

  ClientDashboard({required this.user});

  @override
  _ClientDashboardState createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    saveFCMToken();
  }

  Future<void> saveFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      String nis = widget.user['nis'].toString();

      if (token != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('clients')
            .where('nis', isEqualTo: nis)
            .get();

        if (snapshot.docs.isEmpty) {
          int clientCount =
              (await FirebaseFirestore.instance.collection('clients').get())
                      .docs
                      .length +
                  1;
          String clientId = 'client_$clientCount';

          await FirebaseFirestore.instance
              .collection('clients')
              .doc(clientId)
              .set({
            'id': clientId,
            'nis': nis,
            'token': token,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      print('Gagal menyimpan token ke Firestore: $e');
    }
  }

  List<Map<String, dynamic>> _generateGridItems(Map<String, dynamic> user) {
    return [
      {
        'title': 'Jadwal Sholat',
        'icon': Icons.schedule,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrayerTimesPage()),
          );
        },
      },
      {
        'title': 'Catatan',
        'icon': Icons.note,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotesPage(userId: user['id']),
            ),
          );
        },
      },
      {
        'title': 'Soal & Buku Bos',
        'icon': Icons.book,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SoalBOSClientPage()),
          );
        },
      },
      {
        'title': 'Kalender Akademik',
        'icon': Icons.school,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => KalenderAkademikClientPage()),
          );
        },
      },
      {
        'title': 'Chat with Admin',
        'icon': Icons.chat,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                chatId: 'admin_${user['nis']}',
                identifier: user['nis'].toString(),
                otherUser: 'admin',
              ),
            ),
          );
        },
      },
      {
        'title': 'Kalender Libur',
        'icon': Icons.calendar_today,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DayOffCalendarPage()),
          );
        },
      },
    ];
  }

  List<Widget> _pages(Map<String, dynamic> user) {
    final gridItems = _generateGridItems(user);

    return [
      Column(
        children: [
          _buildUserCard(user),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: gridItems.length,
              itemBuilder: (context, index) {
                final item = gridItems[index];
                return GestureDetector(
                  onTap: () => item['onTap'](context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.powderBlue, // Warna GridView
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'], color: Colors.white, size: 40),
                        SizedBox(height: 10),
                        Text(
                          item['title'],
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      GoogleMapPage(),
      SettingScreen(user: user),
    ];
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Column(
      children: [
        SizedBox(height: 35), // Tambahkan jarak di atas Card
        Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Membuat sudut melengkung
          ),
          elevation: 5, // Memberikan efek bayangan
          shadowColor: Colors.grey.withOpacity(0.5), // Warna bayangan
          color: AppColors.royalBlue, // Warna Card
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
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'NIS: ${user['nis']}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Email: ${user['email']}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Nomor Telepon: ${user['nomor_telepon'] ?? 'Tidak ada'}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.home, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Alamat: ${user['alamat'] ?? 'Tidak ada'}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.class_, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Kelas: ${user['kelas'] ?? 'Tidak ada'}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      backgroundColor: AppColors.skyBlue, // Latar belakang skyBlue
      body: _pages(user)[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.oxfordBlue, // Warna YaleBlue
        selectedItemColor: AppColors.softBeige, // Warna elemen terpilih
        unselectedItemColor:
            AppColors.softBeige.withOpacity(0.7), // Elemen lainnya
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Google Maps'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
