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
  final String apiKey = 'secret';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchVideos(List<String> playlistIds) async {
    List<Map<String, dynamic>> videos = [];

    for (var playlistId in playlistIds) {
      final String apiUrl =
          'https://www.googleapis.com/youtube/v3/playlistItems?key=$apiKey&playlistId=$playlistId&part=snippet&maxResults=150';

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

        if (sentimentScore > 0.1 && isValidUrl(thumbnailUrl) && videoTitle != null) {
          await firestore.collection('swe_videos').add({
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
    List<String> playlistIds = await searchPlaylists('Software engineering');
    print('Playlist IDs: $playlistIds');

    List<Map<String, dynamic>> newVideos = await fetchVideos(playlistIds);

    for (var video in newVideos) {
      bool videoExists = await firestore
          .collection('database_videos') 
          .where('videoId', isEqualTo: video['videoId'])
          .get()
          .then((querySnapshot) => querySnapshot.docs.isNotEmpty);

      if (!videoExists) {
        double sentimentScore = await analyzeSentiment(video['title']);
        print('Sentiment Score: $sentimentScore');

        String videoTitle = video['title'] ?? '';
        String thumbnailUrl = video['thumbnailUrl'] ?? '';

        print('Video Title: $videoTitle');

        if (sentimentScore > 0.1 && isValidUrl(thumbnailUrl) && videoTitle.isNotEmpty) {
          await firestore.collection('swe_videos').add({
            'title': videoTitle,
            'videoId': video['videoId'],
            'videoTitle': videoTitle,
            'thumbnailUrl': thumbnailUrl,
            'sentimentScore': sentimentScore,
          });

          print('Storing good playlist: $videoTitle');
        } else {
          print('Skipping playlist due to low sentiment or missing/invalid thumbnail: $videoTitle');
        }
      }
    }

    print('Sentiment analysis update for database videos completed.');

  } catch (e) {
    print('Error updating database videos: $e');
  }
}

     
Future<List<String>> searchPlaylists(String query) async {
  try {
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/search?key=$apiKey&q=$query&type=playlist&part=id&maxResults=20';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<String> playlistIds = [];

      for (var item in data['items']) {
        playlistIds.add(item['id']['playlistId']);
      }

      return playlistIds;
    } else {
      print('Failed to search for playlists. Status code: ${response.statusCode}, Response body: ${response.body}');
      return [];
    }
  } catch (e) {
    print('Error in searchPlaylists: $e');
    return [];
  }
}

  Future<double> analyzeSentiment(String text) async {
    try {
      return await performSentimentAnalysis(text);
    } catch (e) {
      print('Error in sentiment analysis: $e');
      return 0.0; 
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
        return 0.0; 
      }
    } catch (e) {
      print('Error in analyzeSentiment: $e');
      return 0.0; 
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('YouTube API'),
    ),
    body: Column(
      children: [
        ElevatedButton(
          onPressed: () {
            updatePlaylistData();
          },
          child: Text('Update Playlist Data'),
        ),
      ],
    ),
  );
}

  }
