import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<bool> showMessageList = [false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: (showMessageList.length / 2).ceil(),
          itemBuilder: (context, index) {
            final startIndex = index * 2;
            final endIndex = startIndex + 2;
            final boxes = showMessageList.sublist(
                startIndex, endIndex.clamp(0, showMessageList.length));

            return Row(
              children: boxes
                  .map(
                    (showMessage) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NotificationBox(
                          imagePath: 'images/Success.png',
                          title: 'Perfect Score',
                          message:
                              'Congratulations on achieving a perfect score in the quiz!',
                          showMessage: showMessage,
                          onTap: () {
                            setState(() {
                              showMessageList[startIndex +
                                  boxes.indexOf(showMessage)] = !showMessage;
                            });
                          },
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}

class NotificationBox extends StatelessWidget {
  final String imagePath;
  final String title;
  final String message;
  final bool showMessage;
  final VoidCallback onTap;

  const NotificationBox({
    required this.imagePath,
    required this.title,
    required this.message,
    required this.showMessage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple[100]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                width: 120,
                height: 120,
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 10),
              if (showMessage)
                Text(
                  message,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
