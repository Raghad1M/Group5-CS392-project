import 'package:Journey/NotificationPage.dart';
import 'package:flutter/material.dart';
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
    filteredFavorites = favorites;
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
      // Logic to handle tab changes and filter favorites accordingly
      switch (_tabController!.index) {
        case 0:
          filteredFavorites = favorites; // All
          break;
        case 1:
          filteredFavorites = favorites.where((favorite) => favorite.contains('video')).toList(); // Videos
          break;
        case 2:
          filteredFavorites = favorites.where((favorite) => favorite.contains('article')).toList(); // Articles
          break;
        case 3:
          filteredFavorites = favorites.where((favorite) => favorite.contains('book')).toList(); // Books
          break;
      }
    });
  }

  void addToFavorites(String item) {
    setState(() {
      favorites.add(item);
      _handleTabChange(); // Update the filtered list when a new item is added
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
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
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NotificationPage(),
                ),
              );
            },
          ),
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
                  _handleTabChange(); // Update the filtered list based on search text
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
