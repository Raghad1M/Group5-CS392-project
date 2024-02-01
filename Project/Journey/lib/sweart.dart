import 'package:flutter/material.dart'; 
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart'; 
import 'package:flutter_pdfview/flutter_pdfview.dart'; 
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; 
import 'package:firebase_storage/firebase_storage.dart'; 
 
class ArticleList extends StatefulWidget { 
  @override 
  _FileListPageState createState() => _FileListPageState(); 
} 
class _FileListPageState extends State<ArticleList> { 
  final FirebaseStorage storage = FirebaseStorage.instance; 
  late List<Reference> fileList; 
 
  @override 
  void initState() { 
    super.initState(); 
    fileList = []; // Initialize fileList to an empty list 
    fetchFileList(); 
  } 
 
  Future<void> fetchFileList() async { 
    Reference ref = storage.ref('articles/software engineering/'); 
    ListResult result = await ref.list(); 
 
    setState(() { 
      fileList = result.items; 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text('Articles'), 
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