import 'dart:convert';

import '../env.sample.dart';
import '../models/document.dart';
import 'package:http/http.dart' as http;

import '../models/document_request.dart';
import '../models/models.dart';

Future<Document?> getDocument(String nameAbbr, String studentId) async {
  Document? document;
  try {
    final apiUrl = Uri.https(Env.URL_DOMAIN, Env.URL_DOCUMENT, {
      'student': studentId,
      'name_abbr': nameAbbr,
    });

    final http.Response response = await http.get(apiUrl);
    document = Document.fromJson(jsonDecode(response.body));
  } catch (err) {
    print(err);
  }

  return document;
}

Future<DocumentRequest?> getDocumentRequest(
    String requestedDocument, String studentId) async {
  DocumentRequest? documentRequest;
  try {
    final apiUrl = Uri.https(Env.URL_DOMAIN, Env.URL_REQUEST_DOCUMENT, {
      'student_requested_id': studentId,
      'requested_document': requestedDocument,
    });

    final http.Response response = await http.get(apiUrl);
    documentRequest = DocumentRequest.fromJson(jsonDecode(response.body));
  } catch (err) {
    print(err);
  }

  return documentRequest;
}

Future<http.Response> sendDocumentRequest(String requestedDocument,
    String studentRequestedId, String studentRequestedEmail) async {
  final documentRequest = DocumentRequest(
      requestedDocument: requestedDocument,
      studentRequestedId: studentRequestedId,
      studentRequestedEmail: studentRequestedEmail);

  final jsonData = jsonEncode(documentRequest.toJson());
  final url = Uri.parse(Env.URL_CREATE_REQUEST_DOCUMENT);
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonData,
  );

  return response;
}

Future<List<Document>> getMyDocuments(String studentId) async {
  final apiUrl =
      Uri.https(Env.URL_DOMAIN, Env.URL_DOCUMENT_LIST, {'student': studentId});
  final response = await http.get(apiUrl);

  List<Document> documents = [];

  if (response.statusCode == 200) {
    var items = json.decode(response.body) as List;
    documents = items.map<Document>((json) {
      return Document.fromJson(json);
    }).toList();
  } else {
    print(response.reasonPhrase);
  }

  return documents;
}

Future<Map<String, String>> getFixedDocuments() async {
  final apiUrl = Uri.parse(Env.URL_FIXED_DOCUMENT_LIST);
  final response = await http.get(apiUrl);

  List<FixedDocument> fixedDocuments = [];

  if (response.statusCode == 200) {
    var items = json.decode(response.body) as List;
    fixedDocuments = items.map<FixedDocument>((json) {
      return FixedDocument.fromJson(json);
    }).toList();
  } else {
    print(response.reasonPhrase);
  }
  var fixedDocumentsMap = Map<String, String>();

  try {
    for (var fixedDocument in fixedDocuments) {
      fixedDocumentsMap.putIfAbsent(
          fixedDocument.documentAbbr, () => fixedDocument.documentName);
    }
  } catch (exception) {
    print(exception);
  }

  return fixedDocumentsMap;
}
