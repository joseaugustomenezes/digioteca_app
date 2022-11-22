import 'package:digioteca/app/modules/auth/auth_controller.dart';
import 'package:digioteca/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class RegisterPage extends GetView<AuthController> {
  static final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final FocusNode _email = FocusNode();
  final FocusNode _password = FocusNode();
  final FocusNode _name = FocusNode();
  final FocusNode _school = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.registerEmailField.value,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            errorText: controller.emailError.value == '' ||
                                    controller.emailError.value.isEmpty
                                ? null
                                : controller.emailError.value),
                        focusNode: _email,
                        onFieldSubmitted: (_) {
                          controller.validateEmail(
                              controller.registerEmailField.value.text);
                          FocusScope.of(context).requestFocus(_password);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.registerPasswordField.value,
                        decoration: InputDecoration(hintText: 'Senha'),
                        obscureText: true,
                        focusNode: _password,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_name),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.registerUserNameField.value,
                        decoration: InputDecoration(
                            hintText: 'Nome',
                            errorText: controller.nameError.value == '' ||
                                    controller.nameError.value.isEmpty
                                ? null
                                : controller.nameError.value),
                        focusNode: _name,
                        onFieldSubmitted: (_) {
                          controller.validadeName(
                              controller.registerUserNameField.value.text);
                          FocusScope.of(context).requestFocus(_school);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.registerUserSchoolField.value,
                        decoration: InputDecoration(hintText: 'Escola'),
                        focusNode: _school,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(bottom: 10),
                        child: TextButton(
                          onPressed: () {
                            if (controller.shouldEnableButton()) {
                              _form.currentState!.save();
                              controller.registerUser();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: controller.shouldEnableButton()
                                ? MaterialStateProperty.all(Colors.teal)
                                : MaterialStateProperty.all(Colors.grey),
                            overlayColor: MaterialStateProperty.all(
                              controller.shouldEnableButton()
                                  ? Colors.cyanAccent.withOpacity(0.3)
                                  : Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: controller.isRegistering.value
                                ? Loading()
                                : Text(
                                    'Registrar',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text('Já possui cadastro?'),
                          SizedBox(width: 5),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'Fazer login',
                              style: TextStyle(
                                  color: Colors.teal,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
