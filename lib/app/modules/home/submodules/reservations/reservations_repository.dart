import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digioteca/app/modules/home/submodules/reservations/reservations_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationsRepository {
  Future<List<ReservationsModel>> fetchReservationsFromCurrentUser() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      QuerySnapshot<Map<String, dynamic>>? response;
      List<ReservationsModel> reservations = [];
      response = await db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("reservas")
          .get();

      for (var e in response.docs) {
        final withId = e.data();

        final snap1 = await withId["aluno"].get();
        withId["student"] = snap1.data()["nome"];
        withId["studentId"] = snap1.id;

        final snap2 = await withId["livro"].get();
        withId["book"] = snap2.data()["nome"];
        withId["bookId"] = snap2.id;

        withId["id"] = e.id;
        reservations.add(ReservationsModel.fromJson(withId));
      }
      return reservations;
    } catch (e) {
      throw e;
    }
  }
}
