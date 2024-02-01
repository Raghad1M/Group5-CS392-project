import 'package:flutter/material.dart'; 
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart'; 
import 'package:flutter_pdfview/flutter_pdfview.dart'; 
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; 
import 'package:firebase_storage/firebase_storage.dart'; 
 
class AssignmentPage extends StatefulWidget { 
  @override 
  _FileListPageState createState() => _FileListPageState(); 
} 
class _FileListPageState extends State<AssignmentPage> { 
  final FirebaseStorage storage = FirebaseStorage.instance; 
  late List<Reference> fileList; 
 
  @override 
  void initState() { 
    super.initState(); 
    fileList = []; // Initialize fileList to an empty list 
    fetchFileList(); 
  } 
 
  Future<void> fetchFileList() async { 
    Reference ref = storage.ref('assignments/java/'); 
    ListResult result = await ref.list(); 
 
    setState(() { 
      fileList = result.items; 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text('Assignments'), 
         backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ), 
      body: fileList.isEmpty 
          ? CircularProgressIndicator() 
          : ListView.builder( 
              itemCount: fileList.length, 
              itemBuilder: (context, index) { 
                return ListTile( 
                  title: Text(fileList[index].name), 
                  onTap: () { 
                    Navigator.push( 
                      context, 
                      MaterialPageRoute( 
                        builder: (context) => PdfViewerPage(fileList[index]), 
                      ), 
                    ); 
                  }, 
                ); 
              }, 
            ), 
    ); 
  } 
} 
class PdfViewerPage extends StatelessWidget { 
  final Reference pdfReference; 
 
  const PdfViewerPage(this.pdfReference); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text('PDF Viewer'), 
         backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ), 
      body: FutureBuilder( 
        future: pdfReference.getDownloadURL(), 
        builder: (context, snapshot) { 
          if (snapshot.connectionState == ConnectionState.waiting) { 
            return CircularProgressIndicator(); 
          } else if (snapshot.hasError) { 
            return Center( 
              child: Text('Error loading PDF: ${snapshot.error}'), 
            ); 
          } else { 
            String pdfUrl = snapshot.data.toString(); 
            return SfPdfViewer.network(pdfUrl); 
          } 
        }, 
      ), 
    ); 
  } 
}























/*import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_storage/firebase_storage.dart'; //as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;*/



/*class AssignmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment"),
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ),
      body: FutureBuilder<List<String>>(
        future: _fetchPdfFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<String>? pdfFiles = snapshot.data;
            if (pdfFiles != null && pdfFiles.isNotEmpty) {
              return ListView.builder(
                itemCount: pdfFiles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Assignment ${index + 1}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFViewerScreen(pdfFile: pdfFiles[index]),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Text('No PDF files found.');
            }
          }
        },
      ),
    );
  }

  Future<List<String>> _fetchPdfFiles() async {
  List<String> pdfFiles = [];
  // Get a reference to the "assignments/java" folder
  final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('assignments/java');
  // List all items (files and folders) in the "assignment/java" folder
  firebase_storage.ListResult result = await ref.listAll();
  // Iterate through each item in the result
  for (var item in result.items) {
    // Check if the item is a PDF file
    if (item.name.toLowerCase().endsWith('.pdf')) {
      // Get the download URL for the PDF file
      final String url = await item.getDownloadURL();
      // Add the URL to the list of PDF files
      pdfFiles.add(url);
    }
  }
  return pdfFiles;
}

}

class PDFViewerScreen extends StatelessWidget {
  final String pdfFile;

  PDFViewerScreen({required this.pdfFile});
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ),
      body: FutureBuilder(
        future: _getFileFromUrl(pdfFile),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            File pdf = snapshot.data as File;
            return SfPdfViewer.file(pdf);
          }
        },
      ),
    );
  }

  Future<File> _getFileFromUrl(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/file.pdf');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  } catch (e) {
    print('Error fetching PDF file: $e');
    throw Exception('Failed to fetch PDF file');
  }
}

}*/