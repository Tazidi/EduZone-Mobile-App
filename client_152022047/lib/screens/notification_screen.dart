import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('notifications');
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    databaseRef.onChildAdded.listen((event) {
      setState(() {
        notifications.insert(0, {
          'message': event.snapshot.child('message').value as String,
          'timestamp': event.snapshot.child('timestamp').value as String,
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? Center(child: Text('No notifications yet'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(notification['message']),
                    subtitle: Text(
                      notification['timestamp'],
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
