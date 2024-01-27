import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class NotificationPage extends StatelessWidget {
  static const platform = MethodChannel('your_channel_name');

  Future<void> showNotification() async {
    try {
      await platform.invokeMethod('showNotification', {
        'title': 'New Notification',
        'body': 'You have a new notification!',
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to show notification: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: showNotification,
          child: Text('Show Notification'),
        ),
      ),
    );
  }
}