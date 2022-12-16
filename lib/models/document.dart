class Document {
  final int id;
  final String name;
  final String nameAbbr;
  final String file;
  final String student;

  Document(
      {required this.id,
      required this.name,
      required this.nameAbbr,
      required this.file,
      required this.student});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
        id: json['id'],
        name: json['name'],
        nameAbbr: json['name_abbr'],
        file: json['file'],
        student: json['student']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_abbr': nameAbbr,
        'file': file,
        'student': student
      };
}
