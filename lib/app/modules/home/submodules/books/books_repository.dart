import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digioteca/app/modules/home/submodules/books/books_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BooksRepository {
  Future fetchBooksFromCurrentUser() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      QuerySnapshot<Map<String, dynamic>>? response;
      List<BookModel>? books;
      response = await db
          .collection("users")
          .doc("${auth.currentUser!.uid}")
          .collection("livros")
          .get();

      books = List<BookModel>.from(
        response.docs.map(
          (e) {
            final withId = e.data();
            withId["id"] = e.id;
            return BookModel.fromJson(withId);
          },
        ).toList(),
      );
      return books;
    } catch (e) {
      throw e;
    }
  }
}
