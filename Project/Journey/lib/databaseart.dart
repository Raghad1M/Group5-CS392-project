import 'package:flutter/material.dart'; 
 
void main() { 
  runApp(MyApp()); 
} 
 
class MyApp extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      title: 'Database Articles', 
      home: ArticleList(), 
    ); 
  } 
} 
 
class ArticleList extends StatelessWidget { 
  final List<String> articles = [ 
    'Introduction to Database', 
    'Database it seems like you are interested in an article about databases. Here is an introduction to the topic: Unraveling the World of Databases: A Comprehensive Overview In the realm of information technology, databases play a pivotal role as structured repositories for storing, organizing, and retrieving data. Whether powering a website, supporting business applications, or driving scientific research, databases are the backbone of modern data management. This article explores the fundamentals, types, and applications of databases, shedding light on their critical significance in the digital age  databases are the backbone of the digital age, providing the infrastructure for storing, managing, and retrieving data critical to various applications. As technology advances, the landscape of databases continues to evolve, presenting new challenges and opportunities. Understanding the diverse types of databases and their applications is essential for individuals and organizations navigating the complex world of data management.'
     ]; 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text('Database Articles' ,style: TextStyle(color: Colors.white),
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