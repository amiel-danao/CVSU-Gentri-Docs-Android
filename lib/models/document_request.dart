class DocumentRequest {
  String requestedDocument;
  String studentRequestedId;
  String studentRequestedEmail;

  DocumentRequest(
      {required this.requestedDocument,
      required this.studentRequestedId,
      required this.studentRequestedEmail});

  factory DocumentRequest.fromJson(Map<String, dynamic> json) {
    return DocumentRequest(
        requestedDocument: json['requested_document'],
        studentRequestedId: json['student_requested_id'],
        studentRequestedEmail: json['student_requested_email']);
  }

  Map<String, dynamic> toJson() => {
        "requested_document": requestedDocument,
        "student_requested_id": studentRequestedId,
        "student_requested_email": studentRequestedEmail
      };
}
