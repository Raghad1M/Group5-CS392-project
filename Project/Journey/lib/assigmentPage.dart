import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class AssignmentPage extends StatelessWidget {
  final List<String> pdfFiles; // List of PDF file paths

  AssignmentPage({required this.pdfFiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
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
      ),
    );
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
      ),
      body: PDFView(
        filePath: pdfFile,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onRender: (pages) {
          // PDF document is rendered
        },
        onError: (error) {
          // Handle error
        },
        onPageError: (page, error) {
          // Handle page error
        },
        onViewCreated: (PDFViewController controller) {
          // Do something with the controller
        },
       /* onPageChanged: (int page, int total) {
          setState(() {
                  currentPage = page;
                });
        },*/
      ),
    );
  }
}
