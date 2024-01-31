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
  final Map<String, String> articles = {
    'Introduction to Database': '''
Introduction to Database
Database it seems like you are interested in an article about databases. Here is an introduction to the topic: Unraveling the World of Databases: A Comprehensive Overview In the realm of information technology, databases play a pivotal role as structured repositories for storing, organizing, and retrieving data. Whether powering a website, supporting business applications, or driving scientific research, databases are the backbone of modern data management. This article explores the fundamentals, types, and applications of databases, shedding light on their critical significance in the digital age databases are the backbone of the digital age, providing the infrastructure for storing, managing, and retrieving data critical to various applications. As technology advances, the landscape of databases continues to evolve, presenting new challenges and opportunities. Understanding the diverse types of databases and their applications is essential for individuals and organizations navigating the complex world of data management.
    ''',
     'Overview of SQL': '''
Overview of SQL
SQL (Structured Query Language) is a standard programming language used to manage relational databases and perform various operations such as querying, updating, and deleting data. This article provides an overview of SQL, covering its history, basic syntax, and common commands.

History of SQL:
SQL was developed in the 1970s by IBM researchers as a way to interact with relational databases. It quickly became the standard language for managing data in relational database management systems (RDBMS).

Basic Syntax:
SQL statements are written in a declarative syntax, which means they describe the desired result without specifying the exact steps to achieve it. The basic syntax of SQL includes commands such as SELECT, INSERT, UPDATE, DELETE, and CREATE.

Common Commands:
- SELECT: Retrieves data from one or more tables based on specified criteria.
- INSERT: Adds new rows of data into a table.
- UPDATE: Modifies existing data in a table.
- DELETE: Removes rows of data from a table.
- CREATE: Creates a new table, index, or other database object.

SQL is a powerful language that is widely used in various industries for managing and analyzing data. Understanding SQL fundamentals is essential for anyone working with relational databases.
    '''
    // Add more articles here if needed

  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Database Articles',
          style: TextStyle(color: Colors.white),
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
