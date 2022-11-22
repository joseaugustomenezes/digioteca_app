import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  RxBool isLoginIn = false.obs;
  RxBool isRegistering = false.obs;
  TextEditingController emailTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  Rx<TextEditingController> registerEmailField = TextEditingController().obs;
  Rx<TextEditingController> registerPasswordField = TextEditingController().obs;
  Rx<TextEditingController> registerUserNameField = TextEditingController().obs;
  Rx<TextEditingController> registerUserSchoolField =
      TextEditingController().obs;
  RxString emailErrorMessage = ''.obs;
  RxString passwordErrorMessage = ''.obs;
  RxString emailError = ''.obs;
  RxString nameError = ''.obs;

  Future loginWithEmailAndPassword() async {
    try {
      final bool isEmailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailTextField.text);

      if (!isEmailValid) {
        emailErrorMessage.value = 'Email inválido!';
        passwordErrorMessage.value = '';
      } else if (passwordTextField.text == '') {
        emailErrorMessage.value = '';
        passwordErrorMessage.value = 'Digite sua senha!';
      } else {
        isLoginIn.value = true;
        await _auth.signInWithEmailAndPassword(
            email: emailTextField.text.toLowerCase().trim(),
            password: passwordTextField.text.toLowerCase().trim());
        isLoginIn.value = false;
        Get.offAllNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      emailErrorMessage.value = '';
      if (e.code == "wrong-password") {
        passwordErrorMessage.value = 'Senha incorreta!';
      } else if (e.code == 'user-not-found') {
        emailErrorMessage.value = 'Email não cadastrado!';
        passwordErrorMessage.value = '';
      } else {
        passwordErrorMessage.value = e.code;
      }
    }
  }

  bool shouldEnableButton() {
    if (nameError.value != '' ||
        emailError.value != '' ||
        registerUserNameField.value.text == '' ||
        registerPasswordField.value.text == '' ||
        registerEmailField.value.text == '' ||
        registerUserSchoolField.value.text == '') {
      return false;
    } else {
      return true;
    }
  }

  Future registerUser() async {
    try {
      isRegistering.value = true;
      UserCredential createdUser = await _auth.createUserWithEmailAndPassword(
          email: registerEmailField.value.text,
          password: registerPasswordField.value.text);
      await _db.collection('users').doc(createdUser.user!.uid).set({
        "nome": registerUserNameField.value.text,
        "escola": registerUserSchoolField.value.text
      });
    } on FirebaseAuthException catch (e) {
      print(e.code);
    } finally {
      isRegistering.value = false;
    }
  }

  String validadeName(String value) {
    final bool isValid =
        RegExp(r'^[a-zA-ZáàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ ]+$').hasMatch(value);

    if (!isValid) {
      return nameError.value = 'Nome inválido!';
    } else {
      return nameError.value = '';
    }
  }

  void onRegisterButtonPress() {
    registerEmailField.value.text = '';
    registerPasswordField.value.text = '';
    registerUserNameField.value.text = '';
    registerUserSchoolField.value.text = '';
    emailError.value = '';
    nameError.value = '';
  }

  String validateEmail(String value) {
    final bool isEmailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);

    if (!isEmailValid) {
      return emailError.value = 'Email inválido!';
    } else {
      return emailError.value = '';
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    registerEmailField.value.addListener(() {
      registerEmailField.refresh();
    });
    registerPasswordField.value.addListener(() {
      registerPasswordField.refresh();
    });
    registerUserNameField.value.addListener(() {
      registerUserNameField.refresh();
    });
    registerUserSchoolField.value.addListener(() {
      registerUserSchoolField.refresh();
    });
  }
}
