import 'package:Journey/Login.dart';
import 'package:flutter/material.dart';

import 'user_profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                'images/FirstPage.png',
                height: 380,
                width: 300,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Start your Journey ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ready to embark on a Journey for inspiration and knowledge? Your adventure begins now. Let\'s go!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 118, 117,
                                117) // Adjust the font size as needed
                            ),
                      ),
                      const SizedBox(
                          height: 50), // Add space between the text and button
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 150, 122, 161),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 15), // Adjust button padding
                        ),
                        child: const Text('Let\'s get started'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          PageController controllerInstance = PageController();

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return LoginScreen(
                                    controller:
                                        controllerInstance); // Pass the controller instance
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 245, 230, 232),
                          foregroundColor:
                              const Color.fromARGB(255, 150, 122, 161),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 130,
                              vertical: 15), // Adjust button padding
                        ),
                        child: const Text('Sign in'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
