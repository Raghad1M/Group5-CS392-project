import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


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
              if (index < pdfFiles.length) {
                String selectedPdfFile = pdfFiles[index];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerScreen(pdfFile: selectedPdfFile),
                  ),
                );
              }
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
        backgroundColor: Color.fromARGB(255, 150, 122, 161),
      ),
      body: SfPdfViewer.asset(pdfFile
      ),
    );
  }
}