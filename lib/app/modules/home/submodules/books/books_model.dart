class BookModel {
  String id;
  String name;
  int copy;

  BookModel({required this.id, required this.name, required this.copy});

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      BookModel(id: json["id"], name: json["nome"], copy: json["copia"]);
}
