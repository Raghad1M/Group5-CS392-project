import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Journey/NotificationPage.dart';

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class QuizPageS extends StatefulWidget {

  @override
  _QuizPageState createState() => _QuizPageState();
}


class _QuizPageState extends State<QuizPageS> {
  final CollectionReference achievementsCollection =
      FirebaseFirestore.instance.collection('achievements');
      Achievement? _achievement;

  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;

  List<Question> _questions = [
    Question(
      question: 'Which model is not an agile development method',
      options: [
        'Scrum',
        'Extreme Programming(XP)',
        'Waterfall',
        'Kanban'
      ],
      correctAnswer: 'Waterfall',
    ),
    Question(
      question: 'RUP stands for:',
      options: [
        'Rational Undefined Process',
        'Rational Unfined Process',
        'Record Unit Point',
        'Rational Unit Process'
      ],
      correctAnswer: 'Rational Unfined Process',
    ),
    Question(
      question: 'The difficulty of accommodating change is a disadvantage of:',
      options: [
        'Incremental development',
        'Waterfall model',
        'Reuse oriented model',
        'Agile models'
      ],
      correctAnswer: 'Waterfall model',
    ),
    Question(
      question: 'Risks are explicitly assessed and resolved throughout the process',
      options: [
        'Waterfall',
        'Extreme Programming (XP)',
        'Boehms spiral model',
        'RUP'
      ],
      correctAnswer:
          'Boehms spiral model',
    ),
    Question(
      question: 'pair programming is on of its main features?',
      options: [
        'Waterfall',
        'Extreme Programming (XP)',
        'Boehms spiral model',
        'RUP'
      ],
      correctAnswer: 'Extreme Programming (XP)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes'),
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ),
      body: _buildQuizContent(),
    );
  }

  Widget _buildQuizContent() {
    if (_currentQuestionIndex < _questions.length) {
      return QuizContent(
        question: _questions[_currentQuestionIndex],
        onAnswerSelected: _handleAnswerSelected,
        onNextQuestion: _goToNextQuestion,
        answered: _answered,
      );
    } else {
      return _buildResultPage();
    }
  }

  void _handleAnswerSelected(bool isCorrect) {
    setState(() {
      _answered = true;
      if (isCorrect) {
        _score++;
      }
      if (_score == 5) {
        showAchievementPopup();
      }
    });
  }

  void _goToNextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _answered = false;
    });
  }

  void showAchievementPopup() {
    setState(() {
      _achievement = Achievement(
        title: 'Perfect Score',
        description: 'Congratulations! You achieved a perfect score in Software engineering!',
        imagePath: 'images/Winnersi.png',
      );
    });

    storeAchievementInFirestore(_achievement!, getCurrentUserId()); 

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have earned an achievement for a perfect score!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                navigateToNotificationPage();
              },
              child: Text('View Achievement'),
            ),
          ],
        );
      },
    );
  }

  void storeAchievementInFirestore(Achievement achievement, String userId) {
    achievementsCollection.add({
      'userId': userId,
      'title': achievement.title,
      'description': achievement.description,
      'imagePath': achievement.imagePath,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      print('Achievement added successfully!');
    }).catchError((error) {
      print('Error adding achievement: $error');
    });
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? ''; 
  }


  void navigateToNotificationPage() {
    if (_achievement != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AchievementsPage(),
        ),
      );
    }

  }



  Widget _buildResultPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Quiz Completed',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Text(
            'Score: $_score/${_questions.length}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
              });
            },
            child: Text('Restart Quiz'),
          ),
        ],
      ),
    );
  }
}

class QuizContent extends StatefulWidget {
  final Question question;
  final ValueChanged<bool> onAnswerSelected;
  final VoidCallback onNextQuestion;
  final bool answered;

  QuizContent({
    required this.question,
    required this.onAnswerSelected,
    required this.onNextQuestion,
    required this.answered,
  });

  @override
  _QuizContentState createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  int? _selectedIndex;
  bool _answered = false;

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.question;
    final isAnswered = widget.answered;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentQuestion.question,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: currentQuestion.options.length,
            itemBuilder: (ctx, index) {
              final option = currentQuestion.options[index];
              final isCorrect = option == currentQuestion.correctAnswer;
              final isSelected = _selectedIndex == index;
              Color color;

              if (isAnswered) {
                if (isSelected && isCorrect) {
                  color = Colors.green;
                } else if (isSelected && !isCorrect) {
                  color = Colors.red;
                } else if (!isSelected && isCorrect) {
                  color = Colors.green.withOpacity(0.5);
                } else {
                  color = Colors.transparent;
                }
              } else {
                color = isSelected
                    ? Colors.purple.withOpacity(0.5)
                    : Colors.transparent;
              }

              return GestureDetector(
                onTap: () {
                  if (!isAnswered) {
                    setState(() {
                      _selectedIndex = index;
                      _answered = true;
                      widget.onAnswerSelected(isCorrect);
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  margin: EdgeInsets.only(bottom: 12),
                  child: Text(
                    option,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: isAnswered ? widget.onNextQuestion : null,
            child: Text('Next Question'),
          ),
        ],
      ),
    );
  }
}
