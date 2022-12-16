class FixedDocument {
  final String documentAbbr;
  final String documentName;

  FixedDocument({required this.documentAbbr, required this.documentName});

  factory FixedDocument.fromJson(Map<String, dynamic> json) {
    return FixedDocument(
        documentAbbr: json['document_abbr'],
        documentName: json['document_name']);
  }

  Map<String, dynamic> toJson() =>
      {'document_abbr': documentAbbr, 'document_name': documentName};
}
