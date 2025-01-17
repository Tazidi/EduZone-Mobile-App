import 'package:flutter/material.dart';
import 'package:admin_152022047/screens/admin_dasboard.dart';
import 'package:admin_152022047/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Tetapkan route awal
      routes: {
        '/login': (context) => LoginScreen(),
        '/admin-dashboard': (context) =>
            AdminDashboard(), // Tambahkan route untuk AdminDashboard
      },
    );
  }
}
