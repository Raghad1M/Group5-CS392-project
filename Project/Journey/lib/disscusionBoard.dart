import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

bool isUserAuthenticated() {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null;
}

class Message {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final Timestamp timestamp;
  String fileName;
  String fileExtension;
  String downloadUrl;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    required this.fileName,
    required this.fileExtension,
    required this.downloadUrl,
  });
}

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Message>> getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Message> messages = [];

      for (var doc in snapshot.docs) {
        String senderId = doc['senderId'] ?? '';
        String senderName = doc["senderName"] ?? '';

        if (senderId.isNotEmpty) {
          try {
            DocumentSnapshot<Map<String, dynamic>> userDoc =
                await FirebaseFirestore.instance.collection('users').doc(senderId).get();

            if (userDoc.exists) {
              senderName = userDoc.data()!['name'] ?? "Unknown";
            }
          } catch (e) {
            print('Error fetching user data: $e');
          }
        }

        Timestamp timestamp = doc['timestamp'] ?? Timestamp.now();

        String fileName = doc['fileName'] ?? '';
        String fileExtension = doc['fileExtension'] ?? '';
        String downloadUrl = doc['downloadUrl'] ?? '';

        messages.add(Message(
          id: doc.id,
          content: doc['content'],
          senderId: senderId,
          senderName: senderName,
          timestamp: timestamp,
          fileName: fileName,
          fileExtension: fileExtension,
          downloadUrl: downloadUrl,
        ));
      }

      return messages;
    });
  }

  Future<void> sendFile() async {
    if (!isUserAuthenticated()) {
      print('User not authenticated. Please sign in.');
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      String fileName = file.name ?? '';
      String fileExtension = file.extension ?? '';
      String filePath = file.path!;

      sendMessage(fileName: fileName, fileExtension: fileExtension, filePath: filePath);
    }
  }

  Future<void> sendMessage({
    required String fileName,
    required String fileExtension,
    required String filePath,
  }) async {
    if (!isUserAuthenticated()) {
      print('User not authenticated. Please sign in.');
      return;
    }

    String messageText = _textEditingController.text.trim();
    if (messageText.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          Reference storageReference = FirebaseStorage.instance.ref().child('files/$fileName');
          UploadTask uploadTask = storageReference.putFile(File(filePath));
          await uploadTask.whenComplete(() async {
            String downloadUrl = await storageReference.getDownloadURL();
            await _firestore.collection('messages').add({
              'content': messageText,
              'senderId': user.uid,
              'senderName': user.displayName ?? 'Unknown',
              'timestamp': FieldValue.serverTimestamp(),
              'fileName': fileName,
              'fileExtension': fileExtension,
              'downloadUrl': downloadUrl,
            });
          });
        } catch (e) {
          print("Error sending message: $e");
        }
        _textEditingController.clear();
      }
    }
  }

  void editMessage(String messageId, String newContent) async {
    try {
      await _firestore.collection('messages').doc(messageId).update({
        'content': newContent,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error editing message: $e");
    }
  }

  void deleteMessage(String messageId) async {
    try {
      await _firestore.collection('messages').doc(messageId).delete();
    } catch (e) {
      print("Error deleting message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Discussion Board'),
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
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
                      bool isCurrentUser =
                          FirebaseAuth.instance.currentUser?.uid == message.senderId;

                      return ListTile(
                        title: Text(message.content),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sender: ${message.senderName} - ${message.timestamp.toDate()}',
                            ),
                            if (message.downloadUrl.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('File:'),

                                  Image.network(
                                    message.downloadUrl,
                                    width: 200,
                                    height: 200,
                                  ),
    
                                  Text('PDF File: ${message.fileName}'),

                                ],
                              ),
                          ],
                        ),
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
                  icon: Icon(Icons.add_photo_alternate),
                  onPressed: () {
      
                    sendFile();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (isUserAuthenticated()) {
         
                      sendMessage(fileName: '', fileExtension: '', filePath: '');
                    } else {
                      print('User not authenticated. Please sign in.');
                    }
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
