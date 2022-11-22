import 'package:digioteca/app/modules/home/submodules/reservations/reservations_controller.dart';
import 'package:digioteca/app/modules/home/submodules/reservations/reservations_model.dart';
import 'package:digioteca/shared/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/delete_dialog.dart';
import '../../../../../shared/widgets/loading.dart';

class ReservationsPage extends GetView<ReservationsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.reservations == null
          ? Center(child: Loading())
          : controller.reservations!.isEmpty
              ? EmptyScreen(message: 'Nenhuma reserva cadastrada :/')
              : ListView(
                  children: controller.reservations!
                      .map(
                        (reservation) => ReservationCard(
                          reservation: reservation,
                          onDelete: () {
                            controller.reservedBookId = reservation.id;
                            Get.dialog(
                              DeleteDialog(
                                name: reservation.book,
                                isLoading: controller.isDeletingReservation,
                                onDelete: () async {
                                  await controller.deleteReservation();
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

class ReservationCard extends GetView<ReservationsController> {
  final ReservationsModel reservation;
  final Function() onDelete;

  ReservationCard({required this.reservation, required this.onDelete});

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
                reservation.book,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Aluno(a): ${reservation.student}')
            ],
          ),
          TextButton(
            onPressed: onDelete,
            child: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
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
