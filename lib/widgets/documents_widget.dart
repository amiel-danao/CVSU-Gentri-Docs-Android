import 'dart:convert';

import 'package:auth_service/auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import '../env.sample.dart';
import '../models/document.dart';

class DocumentCard extends StatelessWidget {
  DocumentCard(
      {Key? key,
      required this.nameAbbr,
      required this.label,
      required this.currentStudent})
      : super(key: key);
  final String label;
  final String nameAbbr;
  final Student currentStudent;

  Future<Document?> _getDocument(String nameAbbr) async {
    Document? document;
    try {
      var apiUrl = Uri.parse(
          '${Env.URL_DOCUMENT}?student=${currentStudent.id}&name_abbr=$nameAbbr');

      final http.Response response = await http.get(apiUrl);
      document = Document.fromJson(jsonDecode(response.body));
    } catch (err) {
      print(err);
    }

    return document;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 50,
      shadowColor: Colors.black,
      color: Colors.greenAccent[100],
      child: SizedBox(
        width: 300,
        height: 500,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green[500],
                radius: 64,
                child: const Icon(
                  Icons.file_open,
                  size: 64,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green[900],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: _getDocument(nameAbbr),
                builder:
                    (BuildContext context, AsyncSnapshot<Document?> snapshot) {
                  if (snapshot.hasData) {
                    Document? myDocument = snapshot.data;
                    if (myDocument != null) {
                      return documentButton(
                          'Your can now download your $label by clicking download.',
                          () async => {
                                await FlutterDownloader.enqueue(
                                  url: '${Env.URL_PREFIX}${myDocument.file}',
                                  fileName: myDocument.file.substring(
                                      myDocument.file.lastIndexOf("/") + 1),
                                  savedDir: '/storage/emulated/0/Download',
                                  showNotification:
                                      true, // show download progress in status bar (for Android)
                                  openFileFromNotification:
                                      true, // click on notification to open downloaded file (for Android)
                                )
                              },
                          buttonLabel: 'Download',
                          buttonColor: Colors.green);
                    } else {
                      return documentButton(
                          'Your $label document has errors, Please contact your admin!',
                          null);
                    }
                  } else if (snapshot.hasError) {
                    return documentButton('${snapshot.error.toString()}', null);
                  } else {
                    return documentButton(
                        'Your $label is not yet available for download, but your can request it now by clicking the button below.',
                        () => {});
                  }
                },
              ),
            ],
          ), //Column
        ), //Padding
      ), //SizedBox
    );
  }
}

Widget documentButton(String message, Function()? buttonAction,
    {String buttonLabel = 'Request Now',
    MaterialColor buttonColor = Colors.blue}) {
  return Column(
    children: [
      Text(
        message,
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ), //Textstyle
      ),
      const SizedBox(
        height: 10,
      ),
      if (buttonAction != null) ...[
        ElevatedButton(
          onPressed: buttonAction,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(buttonColor)),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  Icon(Icons.touch_app),
                  Text(
                    buttonLabel,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        )
      ]
    ],
  );
}
