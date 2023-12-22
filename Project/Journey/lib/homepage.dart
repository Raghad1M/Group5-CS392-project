import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class Course {
  final String name;
  final String university;
  final String image;

  Course({required this.name, required this.university, required this.image});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> courses = [
    Course(
      name: 'Operating system',
      university: 'الأمام محمد بن سعود',
      image: 'assets/university_images/abc_university.png',
    ),
    Course(
      name: 'java 1',
      university: 'الامام محمد بن سعود',
      image: 'assets/university_images/xyz_university.png',
    ),
    Course(
      name: 'Database',
      university: ' الامام محمد بن سعود',
      image: 'assets/Screenshot 2023-12-22 220732.png',
    ),
    Course(
      name: 'Software engineering',
      university: ' الامام محمد بن سعود',
      image: 'assets/university_images/pqr_university.png',
    ),
  ];
  List<Course> filteredCourses = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    filteredCourses = courses;
    super.initState();
  }

  void filterCourses(String query) {
    List<Course> filteredList = [];
    if (query.isNotEmpty) {
      filteredList = courses
          .where((course) =>
              course.name.toLowerCase().contains(query.toLowerCase()) ||
              course.university.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      filteredList = courses;
    }
    setState(() {
      filteredCourses = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterCourses,
              decoration: InputDecoration(
                labelText: 'ابحث عن المادة',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: filteredCourses.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        filteredCourses[index].name,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily:
                              'YourCustomFont', // Replace with your desired font family
                        ),
                      ),
                      SizedBox(height: 8),
                      Image.asset(
                        filteredCourses[index].image,
                        width: 80,
                        height: 80,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school,
                            color: Colors.purple,
                          ),
                          SizedBox(width: 4),
                          Text(
                            filteredCourses[index].university,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
