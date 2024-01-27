import 'package:flutter/material.dart';
import 'favorite_items.dart';

class FavoriteButton extends StatefulWidget {
  final int itemIndex;

  const FavoriteButton({Key? key, required this.itemIndex}) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });

        if (isFavorite) {
          // Save the item to favorites
          FavoriteItems.addToFavorites(widget.itemIndex);
        } else {
          // Remove the item from favorites
          FavoriteItems.removeFromFavorites(widget.itemIndex);
        }
      },
    );
  }
}
