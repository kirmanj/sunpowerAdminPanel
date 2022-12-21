import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OpenPdf extends StatefulWidget {
  const OpenPdf({Key? key}) : super(key: key);

  @override
  State<OpenPdf> createState() => _OpenPdfState();
}

class _OpenPdfState extends State<OpenPdf> {
  String path =
      'https://firebasestorage.googleapis.com/v0/b/flutterfirebase-6c279.appspot.com/o/GIS.pdf?alt=media&token=51654170-c140-4ffa-ae1a-9fb431d0dee2';

  Future<void> downloadFile() async {
    final firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('Brandpdf/BMW.pdf');

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File tempFile = File(appDocPath + '/' + 'BMW.pdf');
    try {
      await ref.writeToFile(tempFile);
      await tempFile.create();
      await OpenFile.open(tempFile.path);
    } on firebase_core.FirebaseException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error, file tidak bisa diunduh',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            'File Berhasil diunduh',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).primaryColorLight,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).buttonColor,
              shadowColor: Theme.of(context).shadowColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            onPressed: () async {
              await downloadFile();
            },
            child: Text(
              "Open PDF",
              style: Theme.of(context).textTheme.button!.copyWith(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
            )),
      ),
    );
  }
}
