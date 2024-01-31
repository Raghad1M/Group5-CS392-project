import 'package:flutter/material.dart'; 
 

 
class ArticleList extends StatelessWidget { 
  final Map<String,String> articles = {
    'Introduction to Software Engineering':'''
    Navigating the World of Software Engineering: An In-Depth Overview Software Engineering (SWE) is a multidisciplinary field that involves the systematic design, development, testing, and maintenance of software applications. In an era dominated by technology, software engineers play a pivotal role in shaping the digital landscape. This article explores the fundamentals, methodologies, challenges, and future trends within the realm of Software Engineering Software Engineering is the application of engineering principles to the entire software development process. It encompasses a systematic approach to designing, coding, testing, and maintaining software systems to ensure they meet user requirements and function reliably.Software Engineering is a dynamic and ever-evolving field that plays a critical role in the digital transformation of society. From traditional methodologies to emerging trends like AI and quantum computing, software engineers continue to innovate and overcome challenges. Understanding the principles and practices of Software Engineering is essential for those entering the field and for organizations striving to deliver efficient and reliable software solutions in a rapidly changing technological landscape.
    '''
      // Add more articles here if needed

  }; 
 
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
