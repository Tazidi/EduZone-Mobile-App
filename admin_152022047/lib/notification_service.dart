import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String serverKey =
      'YOUR_SERVER_KEY_HERE'; // Server Key dari Firebase
  static const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  static Future<void> sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'notification': {
            'title': title,
            'body': body,
          },
          'priority': 'high',
          'to': token,
        }),
      );

      if (response.statusCode == 200) {
        print('Notifikasi berhasil dikirim!');
      } else {
        print('Gagal mengirim notifikasi: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static void sendNotificationToMultipleTokens({required List<String> tokens, required String title, required String body}) {}
}
