import 'package:digioteca/app/modules/home/submodules/students/students_controller.dart';
import 'package:digioteca/app/modules/home/submodules/students/students_model.dart';
import 'package:digioteca/app/modules/home/submodules/students/widgets/register_or_edit_student.dart';
import 'package:digioteca/shared/widgets/empty_screen.dart';
import 'package:digioteca/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/delete_dialog.dart';

class StudentsPage extends GetView<StudentsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.students == null
          ? Center(child: Loading())
          : controller.students!.isEmpty
              ? EmptyScreen(message: 'Nenhum aluno cadastrado :/')
              : ListView(
                  children: controller.students!
                      .map(
                        (student) => StudentCard(
                          student: student,
                          onUpdate: () {
                            controller.onEditStudentButtonPress(student);
                            Get.to(() => RegisterOrEditStudent());
                          },
                          onDelete: () {
                            controller.selectedStudentId = student.id;
                            Get.dialog(
                              DeleteDialog(
                                name: student.name,
                                isLoading: controller.isDeletingStudent,
                                onDelete: () async {
                                  await controller.deleteStudent();
                                },
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
    );
  }
}

class StudentCard extends GetView<StudentsController> {
  final StudentModel student;
  final Function() onUpdate;
  final Function() onDelete;

  StudentCard(
      {required this.student, required this.onUpdate, required this.onDelete});

  RxInt selectedOption = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${student.name}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Turma: ${student.schoolClass}'),
                  SizedBox(
                    width: 10,
                  ),
                  student.phone == null
                      ? Container()
                      : Text(
                          'Telefone: (${student.phone.toString().substring(0, 2)})${student.phone.toString().substring(2, 7)}-${student.phone.toString().substring(7, 11)}')
                ],
              )
            ],
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
            onSelected: (value) {
              if (value == 'atualizar') {
                onUpdate();
              } else {
                onDelete();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'atualizar',
                  //onTap: onUpdate,
                  child: Text('Atualizar'),
                ),
                PopupMenuItem<String>(
                  value: 'deletar',
                  //onTap: onDelete,
                  child: Text('Deletar'),
                ),
              ];
            },
          ),
        ],
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 5,
          spreadRadius: 0,
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0.0, 2.0),
        )
      ]),
    );
  }
}
