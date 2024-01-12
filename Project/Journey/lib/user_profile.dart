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
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? name = user.displayName;
        String? email = user.email;

        setState(() {
          _nameController.text = name ?? '';
          _emailController.text = email ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _handleLogout,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('images/Ppic.png'), // Replace with your image path
            ),
            const SizedBox(height: 20.0),
            const SizedBox(height: 20.0),
            _buildEditableField(
              controller: _nameController,
              label: 'Name',
            ),
            const SizedBox(height: 20.0),
            _buildEditableField(
              controller: _emailController,
              label: 'Email',
            ),
            const SizedBox(height: 20.0),
            if (_isEditing) ...[
              _buildPasswordFields(),
              const SizedBox(height: 20.0),
              _buildSaveButton(),
            ],
            if (!_isEditing)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 150, 122, 161),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                ),
                child: const Text('Edit information'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        enabled: _isEditing,
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _oldPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Old Password',
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'New Password',
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        User? user = _auth.currentUser;
        if (user != null) {
          try {
            await user.updateDisplayName(_nameController.text);
            await user.updateEmail(_emailController.text);
            // Update password if provided
            if (_newPasswordController.text.isNotEmpty) {
              await user.updatePassword(_newPasswordController.text);
            }
            setState(() {
              _isEditing = false;
            });
          } catch (e) {
            print('Error updating user: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating user: $e')),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
      ),
      child: Text('Save Changes'),
    );
  }

  void _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/firstPage');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }
}
