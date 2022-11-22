class StudentModel {
  String id;
  String name;
  int? phone;
  String schoolClass;

  StudentModel(
      {required this.id,
      required this.name,
      this.phone,
      required this.schoolClass});

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
      id: json["id"],
      name: json["nome"],
      schoolClass: json["turma"],
      phone: json["telefone"]);
}
