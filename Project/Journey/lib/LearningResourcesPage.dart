import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class LearningResourcesPage extends StatefulWidget {
  @override
  _LearningResourcesPageState createState() => _LearningResourcesPageState();
}

class _LearningResourcesPageState extends State<LearningResourcesPage> {
  List<String> resources = [];

  @override
  void initState() {
    super.initState();
    fetchLearningResources();
  }

  Future<void> fetchLearningResources() async {
    final response = await http.get(Uri.parse('https://www.khanacademy.org/'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the resources
      // Note: The actual structure of the response may vary, you need to analyze the response body structure and extract the relevant data accordingly.
      Map<String, dynamic> data = json.decode(response.body);

      // Assuming 'resources' is a list of strings in the response
      List<dynamic> resourcesData = data['resources'];

      setState(() {
        resources = List<String>.from(resourcesData);
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load learning resources');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Resources'),
      ),
      body: Container(
        color: Color.fromARGB(255, 150, 122, 161),
        child: Center(
          child: Text(
            'Welcome to the Content Page!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
