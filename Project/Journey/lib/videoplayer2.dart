import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListScreen2 extends StatefulWidget {
  @override
  _VideoListScreenState2 createState() => _VideoListScreenState2();
}

class _VideoListScreenState2 extends State<VideoListScreen2> {
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
        title: Text('Video List'),
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

  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: firestore.collection('operating_system_videos').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No videos found.'));
      } else {
        // Filter videos based on the search query
        final filteredVideos = snapshot.data!.docs
            .where((doc) => doc['title'].toLowerCase().contains(query))
            .toList();

        return ListView.builder(
          itemCount: filteredVideos.length,
          itemBuilder: (context, index) {
            var video = filteredVideos[index].data() as Map<String, dynamic>;
              String type = 'video';
            return Column(
              children: [
                ListTile(
                  title: Text(video['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sentiment Score: ${video['sentimentScore']}'),
                      SizedBox(height: 4),
                      if (video['thumbnailUrl'] != null &&
                          video['thumbnailUrl'].isNotEmpty)
                        Image.network(video['thumbnailUrl'],
                            height: 80, width: 120),
                    ],
                  ),
                  trailing: _FavoriteButton(
                    type: type, 
                    title: video['title'] ?? '',
                    url: video['videoId'] ?? '',
                    isVideoInFavorites: isVideoInFavorites,
                    addVideoToFavorites: addVideoToFavorites,
                  ),
                ),
                Divider(), 
              ],
            );
          },
        );
      }
    },
  );
}

  Future<bool> isVideoInFavorites(String type, String title, String url) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      String userId = user?.uid ?? "";

      DocumentReference userFavoriteRef =
          firestore.collection('userFavorites').doc(userId);

      DocumentSnapshot<Map<String, dynamic>> userFavoritesSnapshot =
          await userFavoriteRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      if (userFavoritesSnapshot.exists) {
        List<Map<String, dynamic>> favoriteVideos =
            List.from(userFavoritesSnapshot.data()?['favorites'] ?? []);

        return favoriteVideos.any(
          (Map<String, dynamic> video) =>
              video.containsKey('type') &&
              video.containsKey('title') &&
              video.containsKey('url') &&
              video['type'] == type &&
              video['title'] == title &&
              video['url'] == url,
        );
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  void addVideoToFavorites(String type, Map<String, dynamic> video, bool isFavorite) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;
      String userId = user?.uid ?? "";

      DocumentReference userFavoriteRef =
          firestore.collection('userFavorites').doc(userId);

      DocumentSnapshot<Map<String, dynamic>> userFavoritesSnapshot =
          await userFavoriteRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      if (userFavoritesSnapshot.exists) {
        List<Map<String, dynamic>> favoriteVideos =
            List.from(userFavoritesSnapshot.data()?['favorites'] ?? []);

        // Check if the video is NOT already in favorites
        if (!isFavorite) {
          favoriteVideos.add({'type': type, ...video});
          await userFavoriteRef.set({'favorites': favoriteVideos});
        }
      } else {
        await userFavoriteRef.set({
          'favorites': [
            {'type': type, ...video}
          ]
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
class _FavoriteButton extends StatefulWidget {
  final String type;
  final String title;
  final String url;
  final Function(String, String, String) isVideoInFavorites;
  final Function(String, Map<String, dynamic>, bool) addVideoToFavorites;

  _FavoriteButton({
    required this.type,
    required this.title,
    required this.url,
    required this.isVideoInFavorites,
    required this.addVideoToFavorites,
  });

  @override
  __FavoriteButtonState createState() => __FavoriteButtonState();
}
class __FavoriteButtonState extends State<_FavoriteButton> {
  late Future<bool> _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isVideoInFavorites(widget.type, widget.title, widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isFavorite,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return a loading indicator or default icon
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen2(videoId: widget.url),
                    ),
                  );
                },
                child: Text('Play'),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          // handle error, for now, return default icon
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen2(videoId: widget.url),
                    ),
                  );
                },
                child: Text('Play'),
              ),
            ],
          );
        } else {
          bool isFavorite = snapshot.data ?? false;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () async {
                  // Add await here
                  bool isFavorite = await widget.isVideoInFavorites(widget.type, widget.title, widget.url);
                  widget.addVideoToFavorites(widget.type, {'title': widget.title, 'url': widget.url}, isFavorite);
                  setState(() {
                    _isFavorite = Future.value(!isFavorite);
                  });
                },
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen2(videoId: widget.url),
                    ),
                  );
                },
                child: Text('Play'),
              ),
            ],
          );
        }
      },
    );
  }
}


class VideoPlayerScreen2 extends StatefulWidget {
  final String videoId;

  VideoPlayerScreen2({required this.videoId});

  @override
  _VideoPlayerScreenState2 createState() => _VideoPlayerScreenState2();
}

class _VideoPlayerScreenState2 extends State<VideoPlayerScreen2> {
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
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
        title: Text('Video Player'),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}
