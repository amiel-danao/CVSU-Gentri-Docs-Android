import 'package:auth_service/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/document_controller.dart';
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
  late String userId;
  final fixedDocumentNames = {
    'TOR': 'TOR (Transcript of records)',
    'COG': 'COG (Certificate of Grades)',
    'COR': 'COR (Certificate of records)'
  };
  var fetchedFixedDocumentNames = Map<String, String>();
  late List<DocumentCard> defaultDocuments = [];

  @override
  void initState() {
    super.initState();
    requestPersmission();
    getFixedDocumentNames();

    authProvider = context.read<AuthProvider>();
    userId = widget.currentStudent.userId;
    refreshListView();
  }

  void getFixedDocumentNames() async {
    fetchedFixedDocumentNames = await getFixedDocuments();
    fetchedFixedDocumentNames.addAll(fixedDocumentNames);
  }

  void createInitialFixedDocumentCards() {
    defaultDocuments = [];
    for (var fixedDocument in fetchedFixedDocumentNames.entries) {
      defaultDocuments.add(DocumentCard(
        nameAbbr: fixedDocument.key,
        label: fixedDocument.value,
        studentId: userId,
        studentEmail: widget.currentStudent.email,
      ));
    }
  }

  void requestPersmission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[Permission.storage]);
    }
  }

  Future<void> refreshListView() async {
    defaultDocuments = [];
    var fetchedDocuments = await getMyDocuments(userId);
    var fetchedDocumentCards = <DocumentCard>[];

    for (var document in fetchedDocuments) {
      if (fixedDocumentNames.containsKey(document.nameAbbr)) continue;
      fetchedDocumentCards.add(DocumentCard(
        nameAbbr: document.nameAbbr,
        label: document.name,
        studentId: document.student,
        studentEmail: widget.currentStudent.email,
      ));
    }

    setState(() {
      createInitialFixedDocumentCards();

      defaultDocuments.addAll(fetchedDocumentCards);
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
            currentStudent: widget.currentStudent,
            signOutFunction: () {
              handleSignOut(context, authProvider);
            },
          ),
          body: RefreshIndicator(
              // When the user pulls down on the grid view, call the refresh function
              onRefresh: refreshListView,
              child: ListView.builder(
                padding: EdgeInsets.all(25),
                itemCount: defaultDocuments.length,
                itemBuilder: (BuildContext context, int index) {
                  return defaultDocuments[index];
                },
              ))),
    );
  }
}
