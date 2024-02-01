import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> filteredFavorites = [];
  String searchText = '';

@override
void initState() {
  super.initState();
  _tabController = TabController(length: 4, vsync: this);
  _tabController!.addListener(_handleTabChange);
  _fetchFavorites(); 
}void _handleTabChange() {
  setState(() {
    List<Map<String, dynamic>> searchTextFiltered = favorites
        .where((favorite) =>
            favorite['title'].toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    print('Search text filtered count: ${searchTextFiltered.length}');

    switch (_tabController!.index) {
      case 0:
        filteredFavorites = searchTextFiltered;
        break;
      case 1:
        filteredFavorites = searchTextFiltered.where((favorite) => favorite['type'] == 'video').toList();
        break;
      case 2:
        filteredFavorites = searchTextFiltered.where((favorite) => favorite['type'] == 'article').toList();
        break;
      case 3:
        filteredFavorites = searchTextFiltered.where((favorite) => favorite['type'] == 'assignment').toList();
        break;
    }

    print('Filtered favorites count: ${filteredFavorites.length}');
  });
}
Future<void> _fetchFavorites() async {
  try {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot<Object?> userSnapshot =
          await FirebaseFirestore.instance.collection('userFavorites').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          List<Map<String, dynamic>> userFavorites = List.from(userData['favorites'] ?? [])
              .map((fav) => fav as Map<String, dynamic>)
              .toList();

          print('Fetched favorites: $userFavorites');

          setState(() {
            favorites = userFavorites;
            _handleTabChange();
          });
        }
      }
    }
  } catch (e) {
    print('Error fetching favorites: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Videos'),
            Tab(text: 'Articles'),
            Tab(text: 'Books'),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  _handleTabChange();
                });
              },
            ),
          ),
                      Builder(
                builder: (context) => Expanded(
                  child: ListView.builder(
                    itemCount: filteredFavorites.length,
                    itemBuilder: (context, index) {
                      print('Item count: ${filteredFavorites.length}');
                      return ListTile(
                        title: Text(filteredFavorites[index]['title'] ?? ''),
                        subtitle: Text(filteredFavorites[index]['type'] ?? ''),
                      );
                    },
                  ),
                ),
              ),


        ],
      ),
    );
  }
}
