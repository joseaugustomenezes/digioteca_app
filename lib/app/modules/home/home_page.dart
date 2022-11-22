import 'dart:html' as html;

import 'package:digioteca/app/modules/home/submodules/books/books_controller.dart';
import 'package:digioteca/app/modules/home/submodules/books/books_page.dart';
import 'package:digioteca/app/modules/home/submodules/books/widgets/register_or_edit_book.dart';
import 'package:digioteca/app/modules/home/submodules/reservations/reservations_controller.dart';
import 'package:digioteca/app/modules/home/submodules/reservations/reservations_page.dart';
import 'package:digioteca/app/modules/home/submodules/reservations/widgets/add_reservation_page.dart';
import 'package:digioteca/app/modules/home/submodules/students/students_controller.dart';
import 'package:digioteca/app/modules/home/submodules/students/students_page.dart';
import 'package:digioteca/app/modules/home/submodules/students/widgets/register_or_edit_student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView {
  RxInt selectedIndex = 0.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StudentsController studentsController = Get.find();
  final BooksController booksController = Get.find();
  final ReservationsController reservationsController = Get.find();

  final List<Widget> bottomNavContent = [
    ReservationsPage(),
    BooksPage(),
    StudentsPage(),
  ];

  final Map<int, String> currentRoute = {
    0: 'reservations',
    1: 'books',
    2: 'students'
  };

  final Map<int, String> titulos = {0: 'Reservas', 1: 'Livros', 2: 'Alunos'};

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: bottomNavContent[selectedIndex.value],
        appBar: AppBar(
          title: Text(
            '${titulos[selectedIndex.value]}',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _auth.signOut();
                Get.offAllNamed('/login');
              },
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
          backgroundColor: Colors.teal,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (selectedIndex.value == 0) {
              await reservationsController.fetchAndFilterStudentsAndBooks();
              Get.to(() => AddReservationPage());
            } else if (selectedIndex.value == 1) {
              booksController.onAddBookButtonPress();
              Get.to(() => RegisterOrEditBook());
            } else if (selectedIndex.value == 2) {
              studentsController.onAddStudentButtonPress();
              Get.to(() => RegisterOrEditStudent());
            }
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.teal,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex.value,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.teal,
          fixedColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              label: 'Reservas',
              icon: Icon(
                Icons.receipt_long,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Livros',
              icon: Icon(
                Icons.library_books,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Alunos',
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ],
          onTap: (index) {
            selectedIndex.value = index;
            html.window.history
                .pushState(null, 'Home', '/#/home/${currentRoute[index]}');
          },
        ),
      ),
    );
  }
}
