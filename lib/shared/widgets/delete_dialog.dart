import 'package:digioteca/app/modules/home/submodules/students/students_controller.dart';
import 'package:digioteca/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteDialog extends GetView<StudentsController> {
  final RxBool isLoading;
  final String name;
  final Function()? onDelete;

  DeleteDialog(
      {required this.name, required this.onDelete, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Dialog(
        backgroundColor: Color(0xFFF6F9F9),
        child: Container(
          height: 200,
          child: Column(
            children: [
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text('Tem certeza que deseja deletar $name?'))),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.teal,
                      height: 50,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('VOLTAR',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.red,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          onDelete!();
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: isLoading.value
                              ? Loading()
                              : Text(
                                  'DELETAR',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
