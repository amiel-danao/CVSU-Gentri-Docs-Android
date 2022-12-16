import 'package:auth_service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constants/color_constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../api/student_controller.dart';
import '../providers/auth_provider.dart';
import '../widgets/documents_widget.dart';
import 'my_nav_drawer.dart';
import 'package:permission_handler/permission_handler.dart';

class MyDocumentsPage extends StatefulWidget {
  final Student currentStudent;

  const MyDocumentsPage({Key? key, required this.currentStudent})
      : super(key: key);

  @override
  _MyDocumentsPageState createState() => _MyDocumentsPageState();
}

class _MyDocumentsPageState extends State<MyDocumentsPage> {
  late AuthProvider authProvider;
  final client = http.Client();

  @override
  void initState() {
    super.initState();
    requestPersmission();
    authProvider = context.read<AuthProvider>();
  }

  late List<DocumentCard> items = [
    DocumentCard(
      nameAbbr: 'TOR',
      label: 'TOR (Transcript of records)',
      currentStudent: widget.currentStudent,
    ),
    DocumentCard(
      nameAbbr: 'COG',
      label: 'COG (Certificate of Grades)',
      currentStudent: widget.currentStudent,
    ),
    DocumentCard(
      nameAbbr: 'COR',
      label: 'COR (Certificate of records)',
      currentStudent: widget.currentStudent,
    ),
  ];

  void requestPersmission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[
          Permission.storage]); // it should print PermissionStatus.granted
    }
  }

  // Function to refresh the grid view
  Future<void> refreshGridView() async {
    setState(() {
      items = [
        DocumentCard(
          nameAbbr: 'TOR',
          label: 'TOR (Transcript of records)',
          currentStudent: widget.currentStudent,
        ),
        DocumentCard(
          nameAbbr: 'COG',
          label: 'COG (Certificate of Grades)',
          currentStudent: widget.currentStudent,
        ),
        DocumentCard(
          nameAbbr: 'COR',
          label: 'COR (Certificate of records)',
          currentStudent: widget.currentStudent,
        ),
      ];
    });
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
          body: RefreshIndicator(
            // When the user pulls down on the grid view, call the refresh function
            onRefresh: refreshGridView,
            child: GridView.builder(
              // Set the grid view's item count to the number of items in the list
              itemCount: items.length,
              // Set the grid view's item builder function
              itemBuilder: (context, index) {
                // Return a widget for each item
                return items[index];
              },
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.0,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 5,
                mainAxisExtent: 500,
              ),
              padding: EdgeInsets.all(25),
            ),
          )),
    );
  }
}
