import 'package:Journey/Login.dart';
import 'package:Journey/favpage.dart';
import 'package:Journey/user_profile.dart';
import 'package:flutter/material.dart';

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

class Guesthome extends StatefulWidget {
  const Guesthome({Key? key, required PageController controller})
      : super(key: key);

  @override
  _Guesthome createState() => _Guesthome();
}

class _Guesthome extends State<Guesthome> {
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
        return pop();
      case 2:
        return pop();
      default:
        return SizedBox(); // Return an empty container for unhandled cases
    }
  }

  Widget _buildHomePage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        foregroundColor: const Color.fromARGB(255, 245, 230, 232),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
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
                return Card(
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
        ],
      ),
    );
  }
}

class pop extends StatelessWidget {
  const pop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox( 
            height: 400, 
          ),
          Text(' YOU HAVE TO LOGIN OR SIGN UP!',style: TextStyle( 
                    fontSize: 23, 
                    fontFamily: 'Poppins', 
                    fontWeight: FontWeight.w500, 
                  ),), 
                    SizedBox( 
            height: 30, 
          ),
          ElevatedButton(
            onPressed: () {
              PageController controllerInstance = PageController();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LoginScreen(
                        controller:
                            controllerInstance); 
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 150, 122, 161),
              foregroundColor: const Color.fromARGB(255, 245, 230, 232),

              padding: const EdgeInsets.symmetric(
                  horizontal: 130, vertical: 15), 
            ),
            child: const Text('Sign in'),
          ),
        ],
      )),
    );
  }
}
