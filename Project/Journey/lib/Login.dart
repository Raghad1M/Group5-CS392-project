import 'package:Journey/forgetpass1o2.dart';
import 'package:Journey/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Journey/sing_up_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.controller}) : super(key: key);
  final PageController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text,
      );

      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()), // Navigate to the home page after successful login
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error signing in';

      if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email';
      } else if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password';
      } else {
        errorMessage = 'Something went wrong';
      }

      setState(() {
        _errorMessage = errorMessage; 
      });

    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
  
          SizedBox(
            height: 15,
          ),
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Color.fromARGB(255, 150, 122, 161),
                    fontSize: 27,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: _emailController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 150, 122, 161),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF837E93),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 150, 122, 161),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _passController,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 150, 122, 161),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF837E93),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color.fromARGB(255, 150, 122, 161),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: SizedBox(
                    width: 329,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _login(context), 
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 150, 122, 161),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Don’t have an account?',
                      style: TextStyle(
                        color: Color(0xFF837E93),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: 2.5,
                    ),
                    TextButton(
                      onPressed: () {
                        PageController controllerInstance = PageController();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return SingUpScreen(
                                  controller:
                                      controllerInstance); // Pass the controller instance
                            },
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        primary: Color.fromARGB(255, 150, 122, 161),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    primary: Color.fromARGB(255, 150, 122, 161),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Forgot Password?'),
                ),
                SizedBox(
                  height: 15,
                ),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
