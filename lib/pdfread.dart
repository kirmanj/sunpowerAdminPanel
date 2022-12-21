import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReadPDF extends StatefulWidget {
  String path, title;
  ReadPDF(this.path, this.title);

  @override
  _ReadPDFState createState() => _ReadPDFState();
}

class _ReadPDFState extends State<ReadPDF> {
  Uint8List? _documentBytes;

  @override
  void initState() {
    getPdfBytes();
    super.initState();
  }

  String path =
      "https://firebasestorage.googleapis.com/v0/b/baharka-library-e410f.appspot.com/o/Brandpdf%2F%D8%A8%D8%B1%D8%B3%DB%8C%D8%A7%D8%B1%DB%8C%20%DA%A9%D9%88%D8%B1%D8%AF%DB%8C.pdf?alt=media&token=2f51b90c-1fca-4065-bfdd-236b3cdaa44e";

  void getPdfBytes() async {
    if (kIsWeb) {
      firebase_storage.Reference pdfRef =
          firebase_storage.FirebaseStorage.instanceFor(
                  bucket: 'gs://baharka-library-e410f.appspot.com/Brandpdf')
              .refFromURL(widget.path);
      //size mentioned here is max size to download from firebase.
      await pdfRef.getData(10485760000).then((value) {
        _documentBytes = value;
        setState(() {});
      });
    } else {
      HttpClient client = HttpClient();
      final Uri url = Uri.base.resolve(widget.path);
      final HttpClientRequest request = await client.getUrl(url);
      final HttpClientResponse response = await request.close();
      _documentBytes = await consolidateHttpClientResponseBytes(response);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const Center(child: CircularProgressIndicator());
    if (_documentBytes != null) {
      child = SfPdfViewer.memory(
        _documentBytes!,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: child,
    );
  }
}
