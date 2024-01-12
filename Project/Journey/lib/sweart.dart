import 'package:flutter/material.dart'; 
 
void main() { 
  runApp(MyApp()); 
} 
 
class MyApp extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      title: 'Software Engineering Articles', 
      home: ArticleList(), 
    ); 
  } 
} 
 
class ArticleList extends StatelessWidget { 
  final List<String> articles = [ 
    'Introduction to Software Engineering', 
    'Navigating the World of Software Engineering: An In-Depth Overview Software Engineering (SWE) is a multidisciplinary field that involves the systematic design, development, testing, and maintenance of software applications. In an era dominated by technology, software engineers play a pivotal role in shaping the digital landscape. This article explores the fundamentals, methodologies, challenges, and future trends within the realm of Software Engineering Software Engineering is the application of engineering principles to the entire software development process. It encompasses a systematic approach to designing, coding, testing, and maintaining software systems to ensure they meet user requirements and function reliably.Software Engineering is a dynamic and ever-evolving field that plays a critical role in the digital transformation of society. From traditional methodologies to emerging trends like AI and quantum computing, software engineers continue to innovate and overcome challenges. Understanding the principles and practices of Software Engineering is essential for those entering the field and for organizations striving to deliver efficient and reliable software solutions in a rapidly changing technological landscape.'
    ]; 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text('Software Engineering Articles' ,style: TextStyle(color: Colors.white),
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