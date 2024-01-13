import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeApiExample extends StatefulWidget {
  @override
  _YoutubeApiExampleState createState() => _YoutubeApiExampleState();
}

class _YoutubeApiExampleState extends State<YoutubeApiExample> {
  final String apiKey = 'api key '; 
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchVideos(List<String> playlistIds) async {
    List<Map<String, dynamic>> videos = [];

    for (var playlistId in playlistIds) {
      final String apiUrl =
          'https://www.googleapis.com/youtube/v3/playlistItems?key=$apiKey&playlistId=$playlistId&part=snippet&maxResults=10';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        print('Data: $data');

        if (data['items'] != null) {
          for (var item in data['items']) {
            final snippet = item['snippet'];

            if (snippet != null && snippet['resourceId'] != null && snippet['thumbnails'] != null) {
              String thumbnailUrl = '';
              if (snippet['thumbnails']['high'] != null && snippet['thumbnails']['high']['url'] != null) {
                thumbnailUrl = snippet['thumbnails']['high']['url'];
              }

              videos.add({
                'title': snippet['title'] ?? '',
                'videoId': snippet['resourceId']['videoId'] ?? '',
                'thumbnailUrl': thumbnailUrl,
              });
            }
          }
        }
      } else {
        print('Failed to load videos for playlist $playlistId. Status code: ${response.statusCode}');
      }
    }

    return videos;
  }

  Future<void> storePlaylistsInFirestore(List<Map<String, dynamic>> videos) async {
    for (var video in videos) {
      try {
        print('Processing video: $video');

        double sentimentScore = await analyzeSentiment(video['title']);
        print('Sentiment Score: $sentimentScore');

        String videoTitle = video['title'] ?? '';
        String thumbnailUrl = video['thumbnailUrl'] ?? '';

        print('Video Title: $videoTitle');

        // Check if the sentiment score is high and the thumbnail URL is valid
        if (sentimentScore > 0.1 && isValidUrl(thumbnailUrl) && videoTitle != null) {
          await firestore.collection('good_playlists').add({
            'title': videoTitle,
            'videoId': video['videoId'],
            'videoTitle': videoTitle,
            'sentimentScore': sentimentScore,
          });

          print('Storing good playlist: $videoTitle');
        } else {
          print('Skipping playlist due to low sentiment or missing/invalid thumbnail: $videoTitle');
        }
      } catch (e) {
        print('Error processing video: $e');
      }
    }
  }

  bool isValidUrl(String url) {
    return url != null && url.isNotEmpty;
  }

  Future<void> updatePlaylistData() async {
    try {
      List<String> playlistIds = await searchPlaylists('java');
      print('Playlist IDs: $playlistIds');

      List<Map<String, dynamic>> existingVideos = await firestore.collection('good_playlists').get().then(
        (querySnapshot) {
          List<Map<String, dynamic>> playlists = [];
          for (var doc in querySnapshot.docs) {
            playlists.add(doc.data() as Map<String, dynamic>);
          }
          return playlists;
        },
      );

      List<Map<String, dynamic>> newVideos = await fetchVideos(playlistIds);

      for (var video in newVideos) {
        // Check if the video already exists in the Firestore collection
        bool videoExists = existingVideos.any((existingVideo) => existingVideo['videoId'] == video['videoId']);

        if (!videoExists) {
          double sentimentScore = await analyzeSentiment(video['title']);
          print('Sentiment Score: $sentimentScore');

          String videoTitle = video['title'] ?? '';
          print('Video Title: $videoTitle');

          if (sentimentScore > 0.1 && videoTitle != null) {
            await firestore.collection('good_playlists').add({
              'title': video['title'],
              'videoId': video['videoId'],
              'videoTitle': videoTitle,
              'sentimentScore': sentimentScore,
            });

            print('Storing good playlist: ${video['title']}');
          } else {
            print('Skipping playlist due to low sentiment or missing thumbnail: ${video['title']}');
          }
        }
      }

      print('Sentiment analysis update completed.');
    } catch (e) {
      print('Error updating playlist data: $e');
    }
  }

  Future<List<String>> searchPlaylists(String query) async {
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/search?key=$apiKey&q=$query&type=playlist&part=id&maxResults=5';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<String> playlistIds = [];

      for (var item in data['items']) {
        playlistIds.add(item['id']['playlistId']);
      }

      return playlistIds;
    } else {
      throw Exception('Failed to search for playlists');
    }
  }

  Future<double> analyzeSentiment(String text) async {
    try {
      return await performSentimentAnalysis(text);
    } catch (e) {
      print('Error in sentiment analysis: $e');
      return 0.0; // Default value in case of an error, assuming neutral sentiment
    }
  }

  Future<double> performSentimentAnalysis(String text) async {
    try {
      final String apiUrl = 'https://language.googleapis.com/v1/documents:analyzeSentiment?key=$apiKey';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'document': {'content': text, 'type': 'PLAIN_TEXT'},
          'encodingType': 'UTF8',
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['documentSentiment']['score'].toDouble();
      } else {
        print('Failed to analyze sentiment. Status code: ${response.statusCode}, Response body: ${response.body}');
        return 0.0; // Default value in case of an error, assuming neutral sentiment
      }
    } catch (e) {
      print('Error in analyzeSentiment: $e');
      return 0.0; // Default value in case of an error, assuming neutral sentiment
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube API '),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: firestore.collection('good_playlists').get().then(
          (querySnapshot) {
            List<Map<String, dynamic>> playlists = [];
            for (var doc in querySnapshot.docs) {
              playlists.add(doc.data() as Map<String, dynamic>);
            }
            return playlists;
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No good playlists found.'));
          } else {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Call the function to update playlist data
                    updatePlaylistData();
                  },
                  child: Text('Update Playlist Data'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
