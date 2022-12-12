import 'package:flutter/material.dart';


class DocumentCard extends StatelessWidget {
  DocumentCard(
      {Key? key,
      required this.label})
      : super(key: key);
  final String label;

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
                child: const Icon( // <-- Icon
                  Icons.file_open,
                  size: 64,
                ), //CircleAvatar
              ), //CircleAvatar
              const SizedBox(
                height: 10,
              ), //SizedBox
              Text(
                label,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green[900],
                  fontWeight: FontWeight.w500,
                ), //Textstyle
              ), //Text
              const SizedBox(
                height: 10,
              ), //SizedBox
              Text(
                'Your $label is not yet available for download, but your can request it now by clicking the button below.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                ), //Textstyle
              ), //Text
              const SizedBox(
                height: 10,
              ), //SizedBox
              SizedBox(
                // width: 100,

                child: ElevatedButton(
                  onPressed: () => 'Null',
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green)),
                  child: 
                  Align(alignment: Alignment.center, 
                        child:
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                          children: const [
                            Icon(Icons.touch_app),
                            Text('Request', textAlign: TextAlign.center,)
                          ],
                        ),
                    ),
                  ),
                ),
                // RaisedButton is deprecated and should not be used
                // Use ElevatedButton instead

                // child: RaisedButton(
                //   onPressed: () => null,
                //   color: Colors.green,
                //   child: Padding(
                //     padding: const EdgeInsets.all(4.0),
                //     child: Row(
                //       children: const [
                //         Icon(Icons.touch_app),
                //         Text('Visit'),
                //       ],
                //     ), //Row
                //   ), //Padding
                // ), //RaisedButton
              ) //SizedBox
            ],
          ), //Column
        ), //Padding
      ), //SizedBox
    );
  }
}