import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
void _handleLogout() async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacementNamed(context, '/firstPage');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        automaticallyImplyLeading: false, 
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
         actions: [
          IconButton(
            icon: Icon(Icons.logout), // Icon for logout
            onPressed: _handleLogout, // Calls the logout function
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('images/Ppic.png',),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Container(
                width: double.infinity, // Make the button take the full width
                child: ElevatedButton(
                  onPressed: () {
                    // Save changes logic
                    // Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 150, 122, 161),
                  ),
                  child: const Text('Save changes'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
