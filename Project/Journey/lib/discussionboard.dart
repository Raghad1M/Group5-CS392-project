import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DiscussionProvider(),
      child: MaterialApp(
        title: 'Discussion Board',
        home: DiscussionScreen(),
      ),
    );
  }
}

class DiscussionProvider extends ChangeNotifier {
  List<String> discussions = [];

  void addDiscussion(String discussion) {
    discussions.add(discussion);
    notifyListeners();
  }
}

class DiscussionScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion Board'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<DiscussionProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.discussions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(provider.discussions[index]),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your discussion',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Provider.of<DiscussionProvider>(context, listen: false)
                          .addDiscussion(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: Text('send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
