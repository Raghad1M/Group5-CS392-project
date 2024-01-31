import 'package:flutter/material.dart'; 
 
void main() { 
  runApp(MyApp()); 
} 
 
class MyApp extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      title: 'Java Articles', 
      home: ArticleList(), 
    ); 
  } 
} 
 
class ArticleList extends StatelessWidget { 
  final Map<String,String> articles = {
    'Introduction to Java Programming':'''
   Introduction to Java Programming\n Java is a versatile, object-oriented, and high-performance programming language that has become one of the most popular choices among developers for building a wide range of applications. Developed by James Gosling and his team at Sun Microsystems in the 1990s, Java has evolved into a robust and platform-independent language with a vast ecosystem. Key Features of Java: Platform Independence: One of the defining features of Java is its "Write Once, Run Anywhere" (WORA) capability. Java programs can run on any device that has the Java Virtual Machine (JVM) installed, making it platform-independent. Object-Oriented: Java follows the object-oriented programming paradigm, promoting the use of classes and objects. This approach enhances code modularity, reusability, and maintainability. Security: Java incorporates strong security features to protect systems from malicious attacks. The Java Virtual Machine (JVM) ensures a secure execution environment by preventing unauthorized access to system resources. Multithreading: Java supports multithreading, allowing the concurrent execution of multiple threads within a program. This feature is crucial for developing responsive and efficient applications. Rich Standard Library: Java provides a comprehensive standard library that includes packages and classes for a wide range of functionalities, from networking and database connectivity to graphical user interface (GUI) development. Java Development Environment: To start developing Java applications, developers typically use the Java Development Kit (JDK), which includes the Java compiler (javac), the Java Virtual Machine (JVM), and other tools for debugging and documentation. Integrated Development Environments (IDEs) like Eclipse, IntelliJ IDEA, and NetBeans provide a user-friendly environment for Java development.
   ''' 
     // Add more articles here if needed
  }; 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
       title: Text('Java Articles' ,style: TextStyle(color: Colors.white),
        ),
         backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ), 
      body: ListView.builder( 
        itemCount: articles.length, 
        itemBuilder: (context, index) { 
           var articleTitle = articles.keys.elementAt(index);
          return ListTile( 
            title: Text(articleTitle), 
            onTap: () { 
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetails(articleTitle: articleTitle, articleContent: articles[articleTitle]!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ArticleDetails extends StatelessWidget {
  final String articleTitle;
  final String articleContent;

  ArticleDetails({required this.articleTitle, required this.articleContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          articleTitle,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            articleContent,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
