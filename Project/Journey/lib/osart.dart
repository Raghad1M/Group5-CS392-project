import 'package:flutter/material.dart'; 
 
void main() { 
  runApp(MyApp()); 
} 
 
class MyApp extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      title: 'Operating System Articles', 
      home: ArticleList(), 
    ); 
  } 
} 
 
class ArticleList extends StatelessWidget { 
  final List<String> articles = [ 
    'Introduction to Operating System', 
    'Computing devices, ranging from personal computers to smartphones and servers, rely on a fundamental piece of software known as an Operating System (OS). This article delves into the various aspects of operating systems, exploring their functions, types, evolution, and the challenges and trends shaping their future.Introduction to Operating Systems At its core, an operating system serves as the intermediary between computer hardware and application software. It manages and coordinates various system resources, providing a stable and efficient environment for users to interact with their devices.Types of Operating Systems Single-User, Single-Tasking OS: Designed for individual users performing one task at a time. Single-User, Multi-Tasking OS: Allows a single user to run multiple applications concurrently. Multi-User OS: Supports multiple users running independent processes simultaneously. Real-Time OS: Meets stringent timing requirements for applications like industrial control systems. Distributed OS: Manages a network of computers, treating them as a unified computing resource.'
    ]; 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
       title: Text('Operating System Articles' ,style: TextStyle(color: Colors.white),
        ),
         backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ), 
      body: ListView.builder( 
        itemCount: articles.length, 
        itemBuilder: (context, index) { 
          return ListTile( 
            title: Text(articles[index]), 
            onTap: () { 
              // Add navigation to the article details page or any other action 
              // you want to perform when an article is tapped. 
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetails(articles[index]))); 
            }, 
          ); 
        }, 
      ), 
    ); 
  } 
}