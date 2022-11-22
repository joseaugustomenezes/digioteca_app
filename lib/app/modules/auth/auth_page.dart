import 'package:digioteca/app/modules/auth/auth_controller.dart';
import 'package:digioteca/app/modules/auth/register_page.dart';
import 'package:digioteca/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthPage extends GetView<AuthController> {
  static final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Digioteca',
                      style: TextStyle(
                          fontSize: 80,
                          color: Colors.teal,
                          fontFamily: 'GreatVibes'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: _form,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: controller.emailTextField,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'Digite seu email'),
                              ),
                              ErrorMessage(
                                errorMessage:
                                    controller.emailErrorMessage.value,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: controller.passwordTextField,
                                decoration: InputDecoration(
                                    hintText: 'Digite sua senha'),
                                obscureText: true,
                              ),
                              ErrorMessage(
                                errorMessage:
                                    controller.passwordErrorMessage.value,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              _form.currentState!.save();
                              controller.loginWithEmailAndPassword();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.teal),
                              overlayColor: MaterialStateProperty.all(
                                Colors.teal.withOpacity(0.3),
                              ),
                            ),
                            child: Center(
                              child: controller.isLoginIn.value
                                  ? Loading()
                                  : Text(
                                      'Entrar',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text('Não possui cadastro?'),
                            SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                controller.onRegisterButtonPress();
                                Get.to(() => RegisterPage());
                              },
                              child: Text(
                                'Registrar',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorMessage extends GetView<AuthController> {
  final String errorMessage;

  ErrorMessage({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 10),
      ),
    );
  }
}
