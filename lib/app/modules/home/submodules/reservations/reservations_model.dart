class ReservationsModel {
  String id;
  String student;
  String studentId;
  DateTime createdAt;
  String book;
  String bookId;

  @override
  String toString() {
    return 'ReservationsModel{id: $id, student: $student, studentId: $studentId, createdAt: $createdAt, book: $book, bookId: $bookId}';
  }

  ReservationsModel(
      {required this.id,
      required this.student,
      required this.studentId,
      required this.createdAt,
      required this.book,
      required this.bookId});

  factory ReservationsModel.fromJson(Map<String, dynamic> json) =>
      ReservationsModel(
          id: json["id"],
          student: json["student"],
          studentId: json["studentId"],
          createdAt: json["created_at"].toDate(),
          book: json["book"],
          bookId: json["bookId"]);
}
