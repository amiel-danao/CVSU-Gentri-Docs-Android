import 'package:auth_service/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/student_controller.dart';
import '../providers/auth_provider.dart';
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
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 1, 
      crossAxisSpacing: 16,
      mainAxisSpacing: 16
  ),
  padding: EdgeInsets.all(24),
  children: [
    Icon(Icons.folder_open_outlined, size: 100,),
    Image.network('https://picsum.photos/250?image=2'),
    Image.network('https://picsum.photos/250?image=3'),
    Image.network('https://picsum.photos/250?image=4'),
  ],
),
      ),
    );
  }
}
