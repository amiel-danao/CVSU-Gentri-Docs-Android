import 'dart:convert';
import 'dart:io';
import 'package:flutter_chat_demo/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

import 'package:auth_service/auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../env.sample.dart';
import '../login/view/login_view.dart';
import '../pages/my_documents_page.dart';

// Future<Customer> createProfile(Customer customer) async {

// }

void gotoHomePage(value, context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => MyDocumentsPage(currentStudent: value),
    ),
  );
}

Future<String> createUserProfileIfNotExist(
    Student customer, BuildContext context) async {
  if (customer.email.isEmpty || customer.id.isEmpty) {
    Fluttertoast.showToast(msg: "Invalid login input!");
    throw Exception("Invalid login input!");
  }

  final response =
      await http.get(Uri.parse('${Env.URL_STUDENT}/${customer.id}'));

  if (response.statusCode == 200) {
    Student fetchedCustomer = Student.fromJson(jsonDecode(response.body));
    gotoHomePage(fetchedCustomer, context);
    return "OK";
  } else {
    final jsonData = jsonEncode(customer.toJson());

    final createResponse = await http.post(
      Uri.parse('${Env.URL_STUDENT}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    if (createResponse.statusCode == 201) {
      // func();
      gotoHomePage(customer, context);
      return "OK";
      // return Customer.fromJson(jsonDecode(response.body));
    }

    throw Exception("Sign in fail : ${createResponse.body.toString()}");
  }
}

Future<void> handleSignOut(
    BuildContext context, AuthProvider authProvider) async {
  authProvider.handleSignOut();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginView()),
    (Route<dynamic> route) => false,
  );
}

void uploadImage(
    String url,
    String imageFieldKey,
    Map<String, String> additionalFields,
    BuildContext context,
    void Function(String) func) async {
  final ImagePicker _picker = ImagePicker();
  // Pick an image
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //TO convert Xfile into file
  File file = File(image!.path);

  //print(‘Image picked’);
  var request = http.MultipartRequest('PUT', Uri.parse(url));
  request.fields.addAll(additionalFields);
  request.files.add(http.MultipartFile.fromBytes(
      imageFieldKey, File(file.path).readAsBytesSync(),
      filename: file.path));
  var response = await request.send();
  if (response.statusCode == 200) {
    var responseFromStream = await http.Response.fromStream(response);

    final jsonResponse = json.decode(responseFromStream.body);
    if (jsonResponse[imageFieldKey] != null) {
      func(jsonResponse[imageFieldKey]);
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error uploading image ${response.reasonPhrase}'),
      ),
    );
  }
}