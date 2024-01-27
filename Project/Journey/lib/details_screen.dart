import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final int itemIndex;
    final List<String> favorites;
  DetailsScreen({required this.itemIndex, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
      ),
      body: Center(
        child: Text('Details for Item $itemIndex'),
      ),
    );
  }
}
