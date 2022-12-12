import 'package:auth_service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constants/color_constants.dart';
import 'package:provider/provider.dart';

import '../api/student_controller.dart';
import '../providers/auth_provider.dart';
import '../widgets/documents_widget.dart';
import 'my_nav_drawer.dart';

class MyDocumentsPage extends StatefulWidget {
  final Student currentStudent;
  const MyDocumentsPage({Key? key, required this.currentStudent})
      : super(key: key);

  @override
  _MyDocumentsPageState createState() => _MyDocumentsPageState();
}

class _MyDocumentsPageState extends State<MyDocumentsPage> {
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Documents'),
          backgroundColor: Colors.green[700],
        ),
        drawer: MyNavDrawer(
          currentCustomer: widget.currentStudent,
          signOutFunction: () {
            handleSignOut(context, authProvider);
          },
        ),
        body: GridView(
          shrinkWrap: true,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 5,
                  mainAxisExtent: 500,
                ),
  padding: EdgeInsets.all(25),
  children: [
    DocumentCard(label: 'TOR (Transcript of records)',),
    ElevatedButton.icon(
      onPressed: () {},
      icon: Icon( // <-- Icon
        Icons.file_open,
        size: 24.0,
      ),
      label: Text('TOR (Transcript of records)'), // <-- Text
    ),
    Image.network('https://picsum.photos/250?image=2'),
    Image.network('https://picsum.photos/250?image=3'),
    Image.network('https://picsum.photos/250?image=4'),
  ],
),
      ),
    );
  }
}
