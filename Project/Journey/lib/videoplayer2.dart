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
          final List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredVideos =
              snapshot.data!.docs
                  .where((doc) =>
                      (doc['title'] as String).toLowerCase().contains(query))
                  .toList();

          return ListView.builder(
            itemCount: filteredVideos.length,
            itemBuilder: (context, index) {
              var video = filteredVideos[index];

              return ListTile(
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
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen2(
                          videoId: video['videoId'],
                        ),
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
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }
}
