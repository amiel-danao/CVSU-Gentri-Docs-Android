import 'package:auth_service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/pages/my_documents_page.dart';
import 'package:flutter_chat_demo/pages/profile_page.dart';

class MyNavDrawer extends StatelessWidget {
  final Function() signOutFunction;
  final Student currentCustomer;

  const MyNavDrawer(
      {Key? key, required this.signOutFunction, required this.currentCustomer})
      : super(key: key);

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Image(
              image: AssetImage('images/app_logo.png'),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(currentStudent: currentCustomer)))
            },
          ),
          ListTile(
            leading: Icon(Icons.folder),
            title: Text('My Documents'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyDocumentsPage(currentStudent: currentCustomer)))
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {signOutFunction()},
          ),
        ],
      ),
    );
  }
}
