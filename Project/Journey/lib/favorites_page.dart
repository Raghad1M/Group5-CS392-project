import 'package:flutter/material.dart';
import 'favorite_items.dart';
import 'details_screen.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: FavoriteItems.favorites.length,
        itemBuilder: (BuildContext context, int index) {
          final int itemIndex = FavoriteItems.favorites[index];
          return ListTile(
            title: Text('Favorite Item $itemIndex'),
            onTap: () {
              // Navigate to the details screen for the favorite item
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(itemIndex: itemIndex),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
