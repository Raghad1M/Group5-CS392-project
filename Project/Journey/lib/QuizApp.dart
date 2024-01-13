import 'package:flutter/material.dart';
import 'package:Journey/NotificationPage.dart';

class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  bool _notificationShown =
      false; // Flag to track if NotificationPage has been shown

  List<Question> _questions = [
    Question(
      question: 'Because of virtual memory, the memory can be shared among',
      options: [
        'Processes',
        'Threads',
        'Instructions',
        'none of the mentioned'
      ],
      correctAnswerIndex: 0,
    ),
    // Add more questions here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
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
      if (!_notificationShown) {
        return _buildResultPage();
      } else {
        return Container(); // Return an empty Container if NotificationPage has been shown
      }
    }
  }

  void _handleAnswerSelected(bool isCorrect) {
    setState(() {
      _answered = true;
      if (isCorrect) {
        _score++;
      }
    });
  }

  void _goToNextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _answered = false;
    });

    if (_currentQuestionIndex == _questions.length) {
      _showAchievementPopup();
    }
  }

  void _showAchievementPopup() {
    if (_score == _questions.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You have achieved a perfect score!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('View Achievement Details'),
                onPressed: () {
                  Navigator.pop(context);
                  _showAchievementDetails();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _showAchievementDetails() {
    if (_score == _questions.length) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationPage()),
      ).then((value) {
        // This callback runs when the NotificationPage is popped
        _showAchievementPopup();
        _notificationShown =
            true; // Set the flag to true after NotificationPage is shown
      });
    } else {
      _showAchievementPopup();
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
              final isCorrect = index == currentQuestion.correctAnswerIndex;
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
