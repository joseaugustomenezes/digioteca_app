import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digioteca/app/modules/home/submodules/books/books_controller.dart';
import 'package:digioteca/app/modules/home/submodules/books/books_model.dart';
import 'package:digioteca/app/modules/home/submodules/reservations/reservations_model.dart';
import 'package:digioteca/app/modules/home/submodules/reservations/reservations_repository.dart';
import 'package:digioteca/app/modules/home/submodules/students/students_controller.dart';
import 'package:digioteca/app/modules/home/submodules/students/students_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ReservationsController extends GetxController {
  ReservationsRepository _repository = Get.find();
  StudentsController studentsController = Get.find();
  BooksController booksController = Get.find();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isFechtingReservations = false.obs;
  RxBool isDeletingReservation = false.obs;
  RxBool isAddingReservation = false.obs;

  RxString selectedStudentId = ''.obs;
  RxString selectedBookId = ''.obs;

  Rx<List<ReservationsModel>?> _reservations =
      Rx<List<ReservationsModel>?>(null);
  List<ReservationsModel>? get reservations => _reservations.value;
  set reservations(List<ReservationsModel>? reservations) =>
      _reservations.value = reservations;

  Rx<String?> _reservedBookId = Rx<String?>(null);
  String? get reservedBookId => _reservedBookId.value;
  set reservedBookId(String? reservedBookId) =>
      _reservedBookId.value = reservedBookId;

  Rx<List<StudentModel>> _availableStudents = Rx<List<StudentModel>>([]);
  List<StudentModel> get availableStudents => _availableStudents.value;
  set availableStudents(List<StudentModel> availableStudents) =>
      _availableStudents.value = availableStudents;

  Rx<List<BookModel>> _availableBooks = Rx<List<BookModel>>([]);
  List<BookModel> get availableBooks => _availableBooks.value;
  set availableBooks(List<BookModel> availableBooks) =>
      _availableBooks.value = availableBooks;

  Future fetchReservationsFromCurrentUser() async {
    try {
      isFechtingReservations.value = true;
      reservations = await _repository.fetchReservationsFromCurrentUser();
    } catch (e) {
      print(e);
    } finally {
      isFechtingReservations.value = false;
    }
  }

  Future deleteReservation() async {
    try {
      isDeletingReservation.value = true;
      await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("reservas")
          .doc(reservedBookId)
          .delete();
      await fetchReservationsFromCurrentUser();
    } catch (e) {
      print(e);
    } finally {
      isDeletingReservation.value = false;
    }
  }

  Future fetchAndFilterStudentsAndBooks() async {
    try {
      QuerySnapshot<Map<String, dynamic>> responseStudents;
      QuerySnapshot<Map<String, dynamic>> responseBooks;

      responseStudents = await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("alunos")
          .get();
      responseBooks = await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("livros")
          .get();

      availableStudents = responseStudents.docs.map((e) {
        final withId = e.data();
        withId["id"] = e.id;
        return StudentModel.fromJson(withId);
      }).toList();

      availableBooks = responseBooks.docs.map((e) {
        final withId = e.data();
        withId["id"] = e.id;
        return BookModel.fromJson(withId);
      }).toList();

      selectedStudentId.value = availableStudents.first.id;
      selectedBookId.value = availableBooks.first.id;

      //Todo Filtrar os alunos e livros com reserva.
      // availableStudents = students.where((student) {
      //   for (ReservationsModel reservation in reservations!) {
      //     if (reservation.studentId == student.id) {
      //       return false;
      //     }
      //   }
      //   return true;
      // }).toList();
      //
      // availableBooks = books.where((book) {
      //   for (ReservationsModel reservation in reservations!) {
      //     if (reservation.bookId == book.id) {
      //       return false;
      //     }
      //   }
      //   return true;
      // }).toList();

    } catch (e) {
      print(e);
    }
  }

  Future addReservation() async {
    try {
      isAddingReservation.value = true;
      await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("reservas")
          .doc()
          .set(
        {
          "aluno": _db
              .doc("users/${_auth.currentUser!.uid}/alunos/$selectedStudentId"),
          "created_at": Timestamp.now(),
          "livro":
              _db.doc("users/${_auth.currentUser!.uid}/livros/$selectedBookId")
        },
      );
      await fetchReservationsFromCurrentUser();
      Get.back();
    } catch (e) {
      print(e);
    } finally {
      isAddingReservation.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchReservationsFromCurrentUser();
  }
}
