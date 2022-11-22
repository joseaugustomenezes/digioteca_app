import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digioteca/app/modules/home/submodules/students/students_model.dart';
import 'package:digioteca/app/modules/home/submodules/students/students_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class StudentsController extends GetxController {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  StudentsRepository _repository = Get.find();
  Rx<TextEditingController> studentName = TextEditingController().obs;
  Rx<TextEditingController> phoneNumber = TextEditingController().obs;
  Rx<TextEditingController> schoolClass = TextEditingController().obs;
  RxString studentNameError = ''.obs;
  RxBool isFetchingStudents = false.obs;
  RxBool isAddingStudent = false.obs;
  RxBool isDeletingStudent = false.obs;
  RxBool isUpdatingStudent = false.obs;
  RxBool isStudentBeingAdded = false.obs;
  RxBool isDirty = false.obs;
  final phoneNumberMask = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  Rx<List<StudentModel>?> _students = Rx<List<StudentModel>?>(null);

  List<StudentModel>? get students => _students.value;

  set students(List<StudentModel>? students) => _students.value = students;

  Rx<String?> _selectedStudentId = Rx<String?>(null);
  String? get selectedStudentId => _selectedStudentId.value;
  set selectedStudentId(String? selectedStudent) =>
      _selectedStudentId.value = selectedStudent;

  Future fetchStudentsFromCurrentUser() async {
    try {
      isFetchingStudents.value = true;
      students = await _repository.fetchStudentsFromCurrentUser();
      students!.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      print(e);
    } finally {
      isFetchingStudents.value = false;
    }
  }

  String onlyNumbers(String string) {
    final RegExp regExp = RegExp(r'[0-9]');
    String result = '';
    string.split('').forEach((c) {
      if (regExp.hasMatch(c)) result += c;
    });
    return result;
  }

  String validadeName(String value) {
    final bool isValid =
        RegExp(r'^[a-zA-ZáàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ ]+$').hasMatch(value);

    if (!isValid) {
      return studentNameError.value = 'Nome inválido!';
    } else {
      return studentNameError.value = '';
    }
  }

  Future addStudent() async {
    try {
      isAddingStudent.value = true;
      await _db
          .collection("users")
          .doc("${_auth.currentUser!.uid}")
          .collection("alunos")
          .doc()
          .set(
            phoneNumber.value.text == ''
                ? {
                    "nome": studentName.value.text,
                    "turma": schoolClass.value.text
                  }
                : {
                    "nome": studentName.value.text,
                    "telefone": int.parse(
                      onlyNumbers(phoneNumber.value.text),
                    ),
                    "turma": schoolClass.value.text
                  },
          );
      students = await _repository.fetchStudentsFromCurrentUser();
      students!.sort((a, b) => a.name.compareTo(b.name));
      Get.back();
    } catch (e) {
      print(e);
    } finally {
      isAddingStudent.value = false;
    }
  }

  void onAddStudentButtonPress() {
    isStudentBeingAdded.value = true;
    studentName.value.text = '';
    phoneNumber.value.text = '';
    schoolClass.value.text = '';
    studentNameError.value = '';
  }

  void onEditStudentButtonPress(StudentModel student) {
    isStudentBeingAdded.value = false;
    selectedStudentId = student.id;
    studentName.value.text = student.name;
    phoneNumber.value.text = student.phone == null
        ? ''
        : phoneNumberMask.maskText(student.phone.toString());
    schoolClass.value.text = student.schoolClass;
  }

  bool shouldEnableButton() {
    if (studentNameError.value.isNotEmpty ||
        studentName.value.text.isEmpty ||
        schoolClass.value.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future updateSelectedStudent() async {
    try {
      isUpdatingStudent.value = true;
      await _db
          .collection("users")
          .doc("${_auth.currentUser!.uid}")
          .collection("alunos")
          .doc(selectedStudentId)
          .set(
            phoneNumber.value.text == ''
                ? {
                    "nome": studentName.value.text,
                    "turma": schoolClass.value.text
                  }
                : {
                    "nome": studentName.value.text,
                    "telefone": int.parse(
                      onlyNumbers(phoneNumber.value.text),
                    ),
                    "turma": schoolClass.value.text
                  },
          );
      students = await _repository.fetchStudentsFromCurrentUser();
      students!.sort((a, b) => a.name.compareTo(b.name));
      Get.back();
    } catch (e) {
      print(e);
    } finally {
      isUpdatingStudent.value = false;
    }
  }

  Future deleteStudent() async {
    try {
      isDeletingStudent.value = true;
      await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("alunos")
          .doc(selectedStudentId)
          .delete();
      students = await _repository.fetchStudentsFromCurrentUser();
      students!.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      print(e);
    } finally {
      isDeletingStudent.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchStudentsFromCurrentUser();
    studentName.value.addListener(() {
      studentName.refresh();
    });
    phoneNumber.value.addListener(() {
      phoneNumber.refresh();
    });
    schoolClass.value.addListener(() {
      schoolClass.refresh();
    });
  }
}
