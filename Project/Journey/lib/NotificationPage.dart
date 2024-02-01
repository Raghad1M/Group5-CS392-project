import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  
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


class AchievementsPage extends StatefulWidget {
  @override
  _AchievementsPageState createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final CollectionReference achievementsCollection =
      FirebaseFirestore.instance.collection('achievements');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: achievementsCollection.where('userId', isEqualTo: getCurrentUserId()).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          List<Achievement> achievements = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Achievement(
              title: data['title'],
              description: data['description'],
              imagePath: data['imagePath'],
            );
          }).toList();

          return ListView.builder(
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(achievements[index].title),
                subtitle: Text(achievements[index].description),
                leading: Image.asset(achievements[index].imagePath),
              );
            },
          );
        },
      ),
    );
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? ''; 
  }
}
