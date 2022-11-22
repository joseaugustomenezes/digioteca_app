import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digioteca/app/modules/home/submodules/students/students_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentsRepository {
  Future fetchStudentsFromCurrentUser() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      QuerySnapshot<Map<String, dynamic>>? response;
      List<StudentModel>? students;

      response = await db
          .collection("users")
          .doc("${auth.currentUser!.uid}")
          .collection("alunos")
          .get();

      students = List<StudentModel>.from(response.docs.map((e) {
        final withId = e.data();
        withId["id"] = e.id;
        return StudentModel.fromJson(withId);
      }).toList());

      return students;
    } catch (e) {
      throw e;
    }
  }
}
