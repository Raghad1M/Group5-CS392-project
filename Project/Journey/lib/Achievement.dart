import 'package:flutter/material.dart';
import 'package:Journey/QuizApp.dart';
import 'package:Journey/NotificationPage.dart';

class Achievement {
  static void showAchievement(BuildContext context, int score) {
    if (score == 5) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations!'),
            content:
                Text('You have achieved a perfect score of 5/5 in the quiz!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(),
                    ),
                  );
                },
                child: Text('Show Achievement'),
              ),
            ],
          );
        },
      );
    }
  }
}
