import 'package:Journey/sweart.dart';
import 'package:Journey/videoplayer.dart';
import 'package:Journey/sentimentanalysis.dart';
import 'package:Journey/videoplayer4.dart';
import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Journey/QuizApp.dart';
import 'package:Journey/sweAssignment.dart';

class CourseContentScreen4 extends StatelessWidget {
  const CourseContentScreen4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Content"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBox(context, "Videos", Color.fromARGB(255, 117, 166, 144), course: "java"),
                  _buildBox(context, "Quizzes", Color.fromARGB(255, 249, 197, 83), course: "java"),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBox(context, "Articles", Color.fromARGB(255, 88, 146, 232), course: "Software engineering"),
                  _buildBox(context, "Assignments", Color.fromARGB(255, 160, 109, 192), course: "Software engineering"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox(BuildContext context, String title, Color color, {required String course}) {
    double boxWidth = MediaQuery.of(context).size.width / 2.5;

    Widget screenToNavigate;

    switch (title) {
      case "Videos":
        screenToNavigate = VideoListScreen4();
        break;
      // case "Quizzes":
      // screenToNavigate = QuizPage();
      // break;
    case "Articles":
      screenToNavigate = ArticleList();
      break;
    case "Assignments":
     screenToNavigate = AssignmentPageswe();
    break;
    default:
      screenToNavigate = Container();
  }
    return GestureDetector(
      onTap: () {
        if (screenToNavigate != Container()) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screenToNavigate),
          );
        }
      },
      child: Container(
        width: boxWidth,
        height: boxWidth,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (screenToNavigate != Container()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screenToNavigate),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Click",
                style: TextStyle(fontSize: 14, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
