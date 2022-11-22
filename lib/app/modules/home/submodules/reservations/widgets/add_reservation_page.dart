import 'package:digioteca/app/modules/home/submodules/reservations/reservations_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../shared/widgets/loading.dart';

class AddReservationPage extends GetView<ReservationsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('Adicionar reserva'),
          backgroundColor: Colors.teal,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Livro: ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 0,
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                offset: Offset(0.0, 2.0),
                              )
                            ]),
                            child: DropdownButton(
                              value: controller.selectedBookId.value,
                              isDense: true,
                              isExpanded: true,
                              icon: Icon(Icons.library_books),
                              items: controller.availableBooks
                                  .map(
                                    (book) => DropdownMenuItem(
                                      value: book.id,
                                      child: Text(
                                          '${book.name},copia:${book.copy}'),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                controller.selectedBookId.value =
                                    value as String;
                                controller.selectedBookId.refresh();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aluno(a): ',
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 0,
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                offset: Offset(0.0, 2.0),
                              )
                            ]),
                            child: DropdownButton(
                              value: controller.selectedStudentId.value,
                              isDense: true,
                              isExpanded: true,
                              icon: Icon(Icons.person),
                              items: controller.availableStudents
                                  .map((student) => DropdownMenuItem(
                                      value: student.id,
                                      child: Text(student.name)))
                                  .toList(),
                              onChanged: (value) {
                                controller.selectedStudentId.value =
                                    value as String;
                                controller.selectedStudentId.refresh();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              child: TextButton(
                onPressed: () => controller.addReservation(),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(0),
                      ),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.teal),
                  overlayColor: MaterialStateProperty.all(
                      Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: Center(
                  child: controller.isAddingReservation.value
                      ? Loading()
                      : Text(
                          'Adicionar',
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
