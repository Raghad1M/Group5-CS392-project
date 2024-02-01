import 'package:flutter/material.dart';

class Achievement {
  final String title;
  final String description;
  final String imagePath;

  Achievement({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class NotificationPage extends StatelessWidget {
  final Achievement? achievement;

  NotificationPage({this.achievement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Page'),
      ),
      body: Center(
        child: achievement != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    achievement!.imagePath,
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 10),
                  Text(
                    achievement!.title,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    achievement!.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : Text('No achievements to display.'),
      ),
    );
  }
}