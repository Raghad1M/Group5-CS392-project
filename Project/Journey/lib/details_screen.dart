import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final int itemIndex;

  const DetailsScreen({Key? key, required this.itemIndex}) : super(key: key);

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
