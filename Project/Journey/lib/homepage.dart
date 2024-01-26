import 'package:Journey/course_content1.dart';
import 'package:Journey/course_content2.dart';
import 'package:Journey/course_content3.dart';
import 'package:Journey/course_content4.dart';
import 'package:Journey/disscusionBoard.dart';
import 'package:Journey/favpage.dart';
import 'package:Journey/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:Journey/NotificationPage.dart';

class Course {
  final String name;
  final String university;
  final String image;

  Course({
    required this.name,
    required this.university,
    required this.image,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Course> courses = [
    Course(
      name: 'Operating system',
      university: 'Imamu',
      image: 'images/Ppic.png',
    ),
    Course(
      name: 'Java 1',
      university: 'Imamu',
      image: 'images/Ppic.png',
    ),
    Course(
      name: 'Database',
      university: 'Imamu',
      image: 'images/Ppic.png',
    ),
    Course(
      name: 'Software engineering',
      university: 'Imamu',
      image: 'images/Ppic.png',
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

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return FavoritePage();
      case 2:
        return ProfilePage();
      case 3:
        return ForumScreen(); // Add case for MessagesPage
      default:
        return SizedBox();
    }
  }

  Widget _buildHomePage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NotificationPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterCourses,
              decoration: InputDecoration(
                labelText: 'Search for courses',
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
                return GestureDetector(
                  onTap: () {
                    // Navigate to different screens based on the selected course
                    switch (filteredCourses[index].name) {
                      case 'Operating system':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CourseContentScreen1()),
                        );
                        break;
                      case 'Java 1':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CourseContentScreen2()),
                        );
                        break;
                      case 'Database':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CourseContentScreen3()),
                        );
                        break;
                        case 'Software engineering':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CourseContentScreen4()),
                        );
                        break;
                      // Add cases for other courses as needed
                      default:
                      // Handle cases not specified above
                    }
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          filteredCourses[index].name,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
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
                              Icons.school_rounded,
                              color: Color.fromARGB(255, 150, 122, 161),
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(_currentIndex),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor:
                Color.fromARGB(255, 150, 122, 161), // Set the color here
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Color.fromARGB(255, 150, 122, 161),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messages',
              ),
            ],
          ),
        ));
  }
}
