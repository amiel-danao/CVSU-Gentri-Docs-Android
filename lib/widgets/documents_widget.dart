import 'package:auth_service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/models/document_request.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../api/document_controller.dart';
import '../env.sample.dart';
import '../models/document.dart';

class DocumentCard extends StatefulWidget {
  DocumentCard(
      {Key? key,
      required this.nameAbbr,
      required this.label,
      required this.studentId,
      required this.studentEmail})
      : super(key: key);
  final String label;
  final String nameAbbr;
  final String studentId;
  final String studentEmail;

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  bool _canShowButton = true;

  void hideWidget() {
    setState(() {
      _canShowButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 50,
      shadowColor: Colors.black,
      color: Colors.greenAccent[100],
      child: SizedBox(
        // width: 300,
        // height: 500,
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
                widget.label,
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
                future: getDocument(widget.nameAbbr, widget.studentId),
                builder:
                    (BuildContext context, AsyncSnapshot<Document?> snapshot) {
                  if (snapshot.hasData) {
                    Document? myDocument = snapshot.data;
                    if (myDocument != null) {
                      return documentButton(
                          'Your can now download your ${widget.label} by clicking download.',
                          icon: Icons.download,
                          buttonAction: () async => {
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
                          'Your ${widget.label} document has errors, Please contact your admin!');
                    }
                  } else if (snapshot.hasError) {
                    return documentButton('${snapshot.error.toString()}');
                  } else {
                    return FutureBuilder(
                        initialData: null,
                        future: getDocumentRequest(
                            widget.nameAbbr, widget.studentId),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentRequest?> snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            // Future not done, return a temporary loading widget
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasData) {
                            return Text(
                                'You already requested the file ${widget.label}, Please wait for admin to accept.');
                          } else {
                            return documentButton(
                                'Your ${widget.label} is not yet available for download, but your can request it now by clicking the button below.',
                                buttonAction: !_canShowButton
                                    ? null
                                    : () async {
                                        var response =
                                            await sendDocumentRequest(
                                                widget.nameAbbr,
                                                widget.studentId,
                                                widget.studentEmail);
                                        if (response.statusCode == 201) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'A request for your ${widget.label} has been sent to the admin'),
                                            ),
                                          );
                                          hideWidget();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '${response.reasonPhrase}'),
                                            ),
                                          );
                                          print(
                                              'Request failed with status: ${response.statusCode}');
                                        }
                                      });
                          }
                        });
                  }
                },
              ),
            ],
          ), //Column
        ), //Padding
      ),
    );
  }
}

Widget documentButton(String message,
    {Function()? buttonAction,
    String buttonLabel = 'Request Now',
    MaterialColor buttonColor = Colors.blue,
    bool hideButton = false,
    IconData icon = Icons.touch_app}) {
  return Column(children: [
    if (buttonAction != null && hideButton == false) ...[
      Text(
        message,
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
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
                Icon(icon),
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
  ]);
}
