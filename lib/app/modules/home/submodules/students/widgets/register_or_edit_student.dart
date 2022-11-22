import 'package:digioteca/app/modules/home/submodules/students/students_controller.dart';
import 'package:digioteca/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterOrEditStudent extends GetView<StudentsController> {
  static final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final FocusNode _name = FocusNode();
  final FocusNode _phone = FocusNode();
  final FocusNode _class = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
              ' ${controller.isStudentBeingAdded.value ? 'Adicionar aluno' : 'Atualizar aluno'}'),
          backgroundColor: Colors.teal,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.studentName.value,
                        decoration: InputDecoration(
                            hintText: 'nome',
                            errorText: controller.studentNameError.value ==
                                        '' ||
                                    controller.studentNameError.value.isEmpty
                                ? null
                                : controller.studentNameError.value),
                        focusNode: _name,
                        onChanged: (_) {
                          controller
                              .validadeName(controller.studentName.value.text);
                        },
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_phone),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.phoneNumber.value,
                        inputFormatters: [controller.phoneNumberMask],
                        decoration: InputDecoration(
                          hintText: 'telefone(opcional)',
                        ),
                        focusNode: _phone,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_class),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.schoolClass.value,
                        decoration: InputDecoration(
                          hintText: 'turma',
                        ),
                        focusNode: _class,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 100,
              child: TextButton(
                onPressed: () {
                  if (controller.isStudentBeingAdded.value) {
                    if (controller.shouldEnableButton()) {
                      _form.currentState!.save();
                      controller.addStudent();
                    }
                  } else {
                    if (controller.shouldEnableButton()) {
                      _form.currentState!.save();
                      controller.updateSelectedStudent();
                    }
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(0),
                      ),
                    ),
                  ),
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
                  child: controller.isAddingStudent.value ||
                          controller.isUpdatingStudent.value
                      ? Loading()
                      : Text(
                          '${controller.isStudentBeingAdded.value ? 'Adicionar' : 'Atualizar'}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
