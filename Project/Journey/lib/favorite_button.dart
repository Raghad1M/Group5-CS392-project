import 'package:Journey/favorite_items.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteButton extends StatefulWidget {
  final Map<String, dynamic> video;

  const FavoriteButton({Key? key, required this.video}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late User? _user;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _checkIsFavorite(); 
  }

  Future<void> _checkIsFavorite() async {
    if (_user != null) {

      bool result = await FavoriteItems.isFavoriteForUser(_user!.uid, widget.video['title']);
      setState(() {
        isFavorite = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () async {
    
        if (_user != null) {
          setState(() {
            isFavorite = !isFavorite;
          });

          if (isFavorite) {
            await FavoriteItems.addToFavoritesForUser(_user!.uid, widget.video['title']);
          } else {
            FavoriteItems.removeFromFavoritesForUser(_user!.uid, widget.video['title']);
          }
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Login Required'),
              content: Text('Please log in to add favorites.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
