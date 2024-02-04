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
      university: 'IMISU',
      image: 'images/ossoso.jpg',
    ),
    Course(
      name: 'Java 1',
      university: 'IMISU',
      image: 'images/javajvajva.png',
    ),
    Course(
      name: 'Database',
      university: 'IMISU',
      image: 'images/datdatdtdat.png',
    ),
    Course(
      name: 'Software engineering',
      university: 'IMISU',
      image: 'images/swee.png',
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
      case 3:
        return pop();
      default:
        return SizedBox(); 
    }
  }

  Widget _buildHomePage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>pop(),
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
                childAspectRatio: 1.2,  // Adjusted aspect ratio
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    switch (filteredCourses[index].name) {
                      case 'Operating system':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => pop()),
                        );
                        break;
                      case 'Java 1':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => pop()),
                        );
                        break;
                      case 'Database':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => pop()),
                        );
                        break;
                      case 'Software engineering':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => pop()),
                        );
                        break;
                      default:
                    }
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          filteredCourses[index].name,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 4),
                        Image.asset(
                          filteredCourses[index].image,
                          width: 100,
                          height: 60,
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school_rounded,
                              color: Color.fromARGB(255, 150, 122, 161),
                              size: 16,
                            ),
                            SizedBox(width: 2),
                            Text(
                              filteredCourses[index].university,
                              style: TextStyle(fontSize: 14),
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
);  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(_currentIndex),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor:
                Color.fromARGB(255, 150, 122, 161),
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
class pop extends StatelessWidget {
  const pop({Key? key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'YOU HAVE TO LOGIN OR SIGN UP!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
         color: Color.fromARGB(255, 150, 122, 161),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
              onPressed: () {
                PageController controllerInstance = PageController();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LoginScreen(
                        controller: controllerInstance,
                      );
                    },
                  ),
                );
              },
                style: ElevatedButton.styleFrom(
         backgroundColor: Color.fromARGB(255, 150, 122, 161),
                  onPrimary: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                child: Text('Sign In'),
              ),
              SizedBox(height: 10),

            ],
          ),
        ),
      ),
    );
  }
}