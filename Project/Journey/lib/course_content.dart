import 'package:Journey/videoplayer.dart';
import 'package:Journey/sentimentanalysis.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Journey/QuizApp.dart';
import 'package:Journey/NotificationPage.dart';

class CourseContentScreen extends StatelessWidget {
  const CourseContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Content"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              PageController controllerInstance = PageController();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return NotificationPage(); // Pass the controller instance
                  },
                ),
              );
            },
          ),
        ],
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
                  _buildBox(
                      context, "Videos", Color.fromARGB(255, 117, 166, 144)),
                  _buildBox(
                      context, "Quizzes", Color.fromARGB(255, 249, 197, 83)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBox(
                      context, "Articles", Color.fromARGB(255, 88, 146, 232)),
                  _buildBox(context, "Assignments",
                      Color.fromARGB(255, 160, 109, 192)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox(BuildContext context, String title, Color color) {
    double boxWidth = MediaQuery.of(context).size.width / 2.5;

    Widget screenToNavigate;

    switch (title) {
      case "Videos":
        screenToNavigate = VideoListScreen();
        break;
      case "Quizzes":
        screenToNavigate = QuizPage();
        break;
      case "Articles":
        screenToNavigate = ArticlesScreen();
        break;
      case "Assignments":
        screenToNavigate = AssignmentsScreen();
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
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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

// class QuizApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Quiz"),
//       ),
//       // Add the desired content for the Quiz screen
//     );
//   }
// }
class ArticlesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Articles"),
      ),
      body: Center(
        child: Text("Articles Screen"),
      ),
    );
  }
}

class AssignmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignments"),
      ),
      body: Center(
        child: Text("Assignments Screen"),
      ),
    );
  }
}
