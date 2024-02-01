import 'package:Journey/NotificationPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Journey/QuizApp.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> favorites = [];
  List<String> filteredFavorites = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController!.addListener(_handleTabChange);
    _fetchFavorites(); // Fetch favorites when the page is initialized
  }

  void _handleTabChange() {
    setState(() {
      switch (_tabController!.index) {
        case 0:
          filteredFavorites = favorites;
          break;
        case 1:
          filteredFavorites = favorites.where((favorite) => favorite.contains('video')).toList();
          break;
        case 2:
          filteredFavorites = favorites.where((favorite) => favorite.contains('article')).toList();
          break;
        case 3:
          filteredFavorites = favorites.where((favorite) => favorite.contains('book')).toList();
          break;
      }
    });
  }

  void _fetchFavorites() async {
    // Fetch favorites from the database (Firestore)
    CollectionReference favoritesCollection = FirebaseFirestore.instance.collection('favorites');
    QuerySnapshot querySnapshot = await favoritesCollection.get();

    setState(() {
      // Update the favorites list
      favorites = querySnapshot.docs.map((doc) => doc['title'] as String).toList();
      _handleTabChange(); // Update the filteredFavorites based on the current tab
    });
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
        actions: [
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {
//               Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => NotificationPage(achievement: myAchievement),
//   ),
// );
//             },
//           ),
        ],
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
          Expanded(
            child: ListView.builder(
              itemCount: filteredFavorites.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredFavorites[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
