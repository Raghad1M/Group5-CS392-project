import 'package:Journey/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:Journey/homepage.dart';
import 'package:Journey/Ghome.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/firstPage',
      routes: {
        '/firstPage': (context) => FirstPage(),
        '/LoginScreen': (context) => LoginScreen(controller: PageController(),),
        '/homePage': (context) => HomePage(),
      },
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
                height: 400,
                width: 280,
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
                      const SizedBox(height: 15),
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
                          height: 90), // Add space between the text and button
                      ElevatedButton(
                        onPressed: () {
                          PageController controllerInstance = PageController();

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return Guesthome(
                                    controller:
                                        controllerInstance); // Pass the controller instance
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 150, 122, 161),
                          foregroundColor:
                              const Color.fromARGB(255, 245, 230, 232),
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
