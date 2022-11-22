import 'package:digioteca/app/modules/home/submodules/books/books_controller.dart';
import 'package:digioteca/app/modules/home/submodules/books/books_repository.dart';
import 'package:digioteca/app/modules/home/submodules/reservations/reservations_controller.dart';
import 'package:digioteca/app/modules/home/submodules/reservations/reservations_repository.dart';
import 'package:digioteca/app/modules/home/submodules/students/students_controller.dart';
import 'package:digioteca/app/modules/home/submodules/students/students_repository.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentsRepository(), fenix: true);
    Get.lazyPut(() => StudentsController(), fenix: true);
    Get.lazyPut(() => BooksRepository(), fenix: true);
    Get.lazyPut(() => BooksController(), fenix: true);
    Get.lazyPut(() => ReservationsRepository(), fenix: true);
    Get.lazyPut(() => ReservationsController(), fenix: true);
  }
}
