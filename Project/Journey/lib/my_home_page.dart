import 'package:flutter/material.dart';
import 'favorite_button.dart';
import 'favorites_page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Navigate to the FavoritesPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with the actual number of items
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Item $index'),
            trailing: FavoriteButton(
              itemIndex: index,
            ),
          );
        },
      ),
    );
  }
}
