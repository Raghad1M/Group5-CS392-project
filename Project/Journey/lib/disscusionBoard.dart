import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message {
  final String id;
  final String content;
  final String senderId;
  final String senderName; // Add senderName field
  final Timestamp timestamp;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName, // Initialize senderName
    required this.timestamp,
  });
}

class ForumScreen extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

 
  Stream<List<Message>> getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Message> messages = [];
      for (var doc in snapshot.docs) {
        String senderId = doc['senderId'];
        String senderName = "Unknown";

        if (senderId != null && senderId.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> userDoc =
              await FirebaseFirestore.instance.collection('users').doc(senderId).get();

          if (userDoc.exists) {
            senderName = userDoc.data()!['name'];
          }
        }

        Timestamp timestamp = doc['timestamp'] ?? Timestamp.now();

        messages.add(Message(
          id: doc.id,
          content: doc['content'],
          senderId: senderId,
          senderName: senderName,
          timestamp: timestamp,
        ));
      }
      return messages;
    });
  }



  void sendMessage() {
    String messageText = _textEditingController.text.trim();
    if (messageText.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance.collection('messages').add({
          'content': messageText,
          'senderId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      _textEditingController.clear();
    }
  }

  void deleteMessage(String messageId) {
    FirebaseFirestore.instance.collection('messages').doc(messageId).delete();
  }

  void editMessage(String messageId, String newContent) {
    FirebaseFirestore.instance.collection('messages').doc(messageId).update({
      'content': newContent,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       automaticallyImplyLeading: false, 
        title: Text('discussion board'),
        backgroundColor:Color.fromARGB(255, 150, 122, 161), 
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<Message> messages = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Message message = messages[index];
                      bool isCurrentUser = FirebaseAuth.instance.currentUser?.uid == message.senderId;

                      return ListTile(
                        title: Text(message.content),
                        subtitle: Text('Sender: ${message.senderName} - ${message.timestamp.toDate()}'),
                        trailing: isCurrentUser
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          String newContent = message.content;
                                          return AlertDialog(
                                            title: Text('Edit Message'),
                                            content: TextFormField(
                                              initialValue: message.content,
                                              onChanged: (value) {
                                                newContent = value;
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  editMessage(message.id, newContent);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      deleteMessage(message.id);
                                    },
                                  ),
                                ],
                              )
                            : null,
                        onTap: () {
                          // Implement comment functionality
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
