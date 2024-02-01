import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf/widgets.dart' as pw;

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
                                  if (message.fileExtension.toLowerCase() == 'pdf')
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PDFScreen(
                                              pdfUrl: message.downloadUrl,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('View PDF'),
                                    )
                                  else
                                    Image.network(
                                      message.downloadUrl,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  Text('File Name: ${message.fileName}'),
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
                          // Handle tapping on the message if needed
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
                    // Send the file (image, video, pdf, etc.)
                    sendFile();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (isUserAuthenticated()) {
                      // Send a text message
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
class PDFScreen extends StatelessWidget {
  final String pdfUrl;

  PDFScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ),
      body: SafeArea(
        child: _buildPdfViewer(),
      ),
    );
  }

  Widget _buildPdfViewer() {
    try {
return SfPdfViewer.network(
  pdfUrl,

);
    } catch (e) {
      print('Error loading PDF: $e');
      // Handle the error as needed.
      return Center(
        child: Text('Error loading PDF'),
      );
    }
  }
}