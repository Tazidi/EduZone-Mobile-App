import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Simpan token FCM dengan ID yang bertambah (client_1, client_2, ...)
  Future<void> saveFCMToken() async {
    try {
      // Dapatkan token FCM
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        // Ambil jumlah dokumen yang ada di koleksi 'clients'
        QuerySnapshot snapshot = await _firestore.collection('clients').get();
        int clientCount =
            snapshot.docs.length + 1; // Hitung jumlah dokumen, tambahkan 1
        String clientId = 'client_$clientCount'; // Buat ID dokumen baru

        // Simpan token ke Firestore
        await _firestore.collection('clients').doc(clientId).set({
          'id': clientId,
          'token': token,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print('Token berhasil disimpan untuk $clientId');
      }
    } catch (e) {
      print('Gagal menyimpan token ke Firestore: $e');
    }
  }
}
