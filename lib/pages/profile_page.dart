import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auth_service/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constants/app_constants.dart';
import 'package:flutter_chat_demo/constants/constants.dart';
import 'package:flutter_chat_demo/providers/providers.dart';
import 'package:flutter_chat_demo/widgets/loading_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../api/student_controller.dart';
import '../env.sample.dart';
import '../widgets/profile_widgets.dart';
import 'my_documents_page.dart';

class ProfilePage extends StatelessWidget {
  final Student currentStudent;
  ProfilePage({Key? key, required this.currentStudent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: Text(
          AppConstants.profileTitle,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ProfilePageState(currentStudent: currentStudent),
    );
  }
}

class ProfilePageState extends StatefulWidget {
  final Student currentStudent;
  ProfilePageState({Key? key, required this.currentStudent}) : super(key: key);

  @override
  State createState() => ProfilePageStateState();
}

class ProfilePageStateState extends State<ProfilePageState> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mobileController;

  String photoUrl = '';
  bool isLoading = false;
  File? avatarImageFile;
  late SettingProvider settingProvider;

  @override
  void initState() {
    super.initState();
    settingProvider = context.read<SettingProvider>();
    String? picture = widget.currentStudent.picture;
    photoUrl = picture!;

    _emailController = TextEditingController(text: widget.currentStudent.email);
    _firstNameController =
        TextEditingController(text: widget.currentStudent.firstName);
    _middleNameController =
        TextEditingController(text: widget.currentStudent.middleName);
    _lastNameController =
        TextEditingController(text: widget.currentStudent.lastName);
    _mobileController =
        TextEditingController(text: widget.currentStudent.mobile);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _emailController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> handleUpdateData() async {
    setState(() {
      isLoading = true;
    });

    final body = {
      'firstname': _firstNameController.text,
      'middlename': _middleNameController.text,
      'lastname': _lastNameController.text,
      'email': _emailController.text,
      'mobile': _mobileController.text
    };

    final url = Uri.parse('${Env.URL_STUDENT}/${widget.currentStudent.userId}');
    final patchResponse = await http.patch(url, body: body);

    if (patchResponse.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update success'),
        ),
      );
      setState(() {
        isLoading = false;
      });

      Student updatedStudent = Student.fromJson(jsonDecode(patchResponse.body));

      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyDocumentsPage(currentStudent: updatedStudent)));
    } else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update failed : ${patchResponse.body.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Avatar
                  // CupertinoButton(
                  //   onPressed: () {},
                  //   child: Container(
                  //     margin: EdgeInsets.all(10),
                  //     child: avatarImageFile == null
                  //         ? photoUrl.isNotEmpty
                  //             ? ClipRRect(
                  //                 borderRadius: BorderRadius.circular(45),
                  //                 child: Image.network(
                  //                   photoUrl,
                  //                   fit: BoxFit.cover,
                  //                   width: 90,
                  //                   height: 90,
                  //                   errorBuilder:
                  //                       (context, object, stackTrace) {
                  //                     return Icon(
                  //                       Icons.account_circle,
                  //                       size: 90,
                  //                       color: ColorConstants.greyColor,
                  //                     );
                  //                   },
                  //                   loadingBuilder: (BuildContext context,
                  //                       Widget child,
                  //                       ImageChunkEvent? loadingProgress) {
                  //                     if (loadingProgress == null) return child;
                  //                     return Container(
                  //                       width: 90,
                  //                       height: 90,
                  //                       child: Center(
                  //                         child: CircularProgressIndicator(
                  //                           color: ColorConstants.themeColor,
                  //                           value: loadingProgress
                  //                                       .expectedTotalBytes !=
                  //                                   null
                  //                               ? loadingProgress
                  //                                       .cumulativeBytesLoaded /
                  //                                   loadingProgress
                  //                                       .expectedTotalBytes!
                  //                               : null,
                  //                         ),
                  //                       ),
                  //                     );
                  //                   },
                  //                 ),
                  //               )
                  //             : Icon(
                  //                 Icons.account_circle,
                  //                 size: 90,
                  //                 color: ColorConstants.greyColor,
                  //               )
                  //         : ClipRRect(
                  //             borderRadius: BorderRadius.circular(45),
                  //             child: Image.file(
                  //               avatarImageFile!,
                  //               width: 90,
                  //               height: 90,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //   ),
                  // ),
                  // TextButton(
                  //     onPressed: () {
                  //       uploadImage(
                  //           '${Env.URL_CUSTOMER_IMAGE}/${widget.currentStudent.userId}',
                  //           'picture',
                  //           {'user_id': widget.currentStudent.userId},
                  //           context,
                  //           (value) => setState(() {
                  //                 photoUrl = value;
                  //               }));
                  //     },
                  //     child: Text('Change Photo')),
                  const SizedBox(height: 20.0),
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Student No: ${widget.currentStudent.studentID}'),
                        const SizedBox(height: 15.0),
                        ProfileAccountName(
                          controller: _firstNameController,
                          placeHolder: 'First name',
                          textValidator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length == 0)
                              return "Please input First name";
                            else
                              return null;
                          },
                        ),
                        const SizedBox(height: 15.0),
                        ProfileAccountName(
                          controller: _middleNameController,
                          placeHolder: 'Middle name',
                        ),
                        const SizedBox(height: 15.0),
                        ProfileAccountName(
                          controller: _lastNameController,
                          placeHolder: 'Last name',
                          textValidator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length == 0)
                              return "Please input Last name";
                            else
                              return null;
                          },
                        ),
                        const SizedBox(height: 15.0),
                        ProfileAccountEmail(
                          emailController: _emailController,
                          readOnly: true,
                        ),
                        const SizedBox(height: 15.0),
                        ProfileAccountPhone(phoneController: _mobileController),
                        const SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          handleUpdateData();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Invalid profile input!"),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColorConstants.primaryColor),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.fromLTRB(30, 10, 30, 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),

        // Loading
        Positioned(child: isLoading ? LoadingView() : SizedBox.shrink()),
      ],
    );
  }
}
