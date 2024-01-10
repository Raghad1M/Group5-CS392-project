import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:convert'; 
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; 
 
class VideoItem { 
  final String title; 
  final String videoId; 
  final String thumbnailUrl; 
 
  VideoItem({ 
    required this.title, 
    required this.videoId, 
    required this.thumbnailUrl, 
  }); 
} 
 
class java1 extends StatefulWidget { 
  @override 
  _java1 createState() => _java1(); 
} 
 
class _java1 extends State<java1> { 
  List<VideoItem> videos = []; 
 
  @override 
  void initState() { 
    super.initState(); 
    fetchVideos(); 
  } 
  Future<void> fetchVideos() async { 
  final String apiKey = 'AIzaSyAfN3Y7qqJ32kFe_bptJh-zjqj-NVTYGqY'; 
  final String playlistId = 'PLA70DBE71B0C3B142'; // Replace with your playlist ID 
  final String apiUrl = 
      'https://www.googleapis.com/youtube/v3/playlistItems?key=$apiKey&playlistId=$playlistId&part=snippet&maxResults=10'; 
 
  final response = await http.get(Uri.parse(apiUrl)); 
 
  if (response.statusCode == 200) { 
    final Map<String, dynamic> data = json.decode(response.body); 
    List<VideoItem> fetchedVideos = []; 
 
    for (var item in data['items']) { 
      fetchedVideos.add(VideoItem( 
        title: item['snippet']['title'], 
        videoId: item['snippet']['resourceId']['videoId'], 
        thumbnailUrl: item['snippet']['thumbnails']['high']['url'], 
      )); 
    } 
 
    setState(() { 
      videos = fetchedVideos; 
    }); 
  } else { 
    throw Exception('Failed to load videos'); 
  } 
} 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text('YouTube Videos'), 
      ), 
      body: ListView.builder( 
        itemCount: videos.length, 
        itemBuilder: (context, index) { 
          return Card( 
            elevation: 4, 
            margin: EdgeInsets.all(8), 
            child: InkWell( 
              onTap: () { 
                Navigator.push( 
                  context, 
                  MaterialPageRoute( 
                    builder: (context) => VideoScreen( 
                      videoId: videos[index].videoId, 
                    ), 
                  ), 
                ); 
              }, 
              child: Padding( 
                padding: EdgeInsets.all(8), 
                child: Row( 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [ 
                    Image.network( 
                      videos[index].thumbnailUrl, 
                      height: 100, 
                      width: 160, 
                      fit: BoxFit.cover, 
                    ), 
                    SizedBox(width: 12), 
                    Expanded( 
                      child: Text( 
                        videos[index].title, 
                        style: TextStyle(fontSize: 16), 
                      ), 
                    ), 
                  ], 
                ), 
              ), 
            ), 
          ); 
        }, 
      ), 
    ); 
  } 
} 
 
class VideoScreen extends StatelessWidget { 
  final String videoId; 
 
  const VideoScreen({Key? key, required this.videoId}) : super(key: key); 
 
  @override 
  Widget build(BuildContext context) { 
    YoutubePlayerController _controller = YoutubePlayerController( 
      initialVideoId: videoId, 
      flags: YoutubePlayerFlags( 
        autoPlay: true, 
        mute: false, 
      ), 
    ); 
 
    return Scaffold( 
      appBar: AppBar( 
        title: Text('YouTube Video'), 
      ), 
      body: Center( 
        child: YoutubePlayer( 
          controller: _controller, 
          showVideoProgressIndicator: true, 
          progressIndicatorColor: Colors.blueAccent, 
          progressColors: ProgressBarColors( 
            playedColor: Colors.blue, 
            handleColor: Colors.blueAccent, 
          ), 
          onReady: () { 
            // Perform actions on player ready 
          }, 
            onEnded: (metaData) { 
            // Perform actions when video ends 
          }, 
        ), 
      ), 
    ); 
  } 
}