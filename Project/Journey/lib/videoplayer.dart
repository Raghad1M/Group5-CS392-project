import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListScreen extends StatefulWidget {
  final String course;

  VideoListScreen({required this.course});

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
        title: Text('${widget.course} Video List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search videos...',
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final String query = _searchController.text.toLowerCase();

    return StreamBuilder(
      stream: firestore.collection('${widget.course}_playlists').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No videos found.'));
        } else {
          final List<Map<String, dynamic>> filteredVideos = snapshot.data!.docs
              .where((doc) => (doc['title'] as String).toLowerCase().contains(query))
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          return ListView.builder(
            itemCount: filteredVideos.length,
            itemBuilder: (context, index) {
              var video = filteredVideos[index];

              return ListTile(
                title: Text(video['title']),
                subtitle: Text('Sentiment Score: ${video['sentimentScore']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FavoriteButton(itemIndex: index),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerScreen(videoId: video['videoId']),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 150, 122, 161),
                        ),
                      ),
                      child: Text('Play'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class FavoriteButton extends StatefulWidget {
  final int itemIndex;

  const FavoriteButton({Key? key, required this.itemIndex}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
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

class FavoriteItems {
  static List<int> favorites = [];

  static void addToFavorites(int itemIndex) {
    favorites.add(itemIndex);
  }

  static void removeFromFavorites(int itemIndex) {
    favorites.remove(itemIndex);
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  VideoPlayerScreen({required this.videoId});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }
}
