import 'package:digioteca/app/modules/home/submodules/books/books_controller.dart';
import 'package:digioteca/app/modules/home/submodules/books/books_model.dart';
import 'package:digioteca/app/modules/home/submodules/books/widgets/register_or_edit_book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/delete_dialog.dart';
import '../../../../../shared/widgets/empty_screen.dart';
import '../../../../../shared/widgets/loading.dart';

class BooksPage extends GetView<BooksController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.books == null
          ? Center(child: Loading())
          : controller.books!.isEmpty
              ? EmptyScreen(message: 'Nenhum livro cadastrado :/')
              : ListView(
                  children: controller.books!
                      .map(
                        (book) => BookCard(
                          book: book,
                          onUpdate: () {
                            controller.onEditBookButtonPress(book);
                            Get.to(() => RegisterOrEditBook());
                          },
                          onDelete: () {
                            controller.selectedBookId = book.id;
                            Get.dialog(
                              DeleteDialog(
                                name: book.name,
                                isLoading: controller.isDeletingBook,
                                onDelete: () async {
                                  await controller.deleteBook();
                                },
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
    );
    ;
  }
}

class BookCard extends GetView {
  final BookModel book;
  final Function() onUpdate;
  final Function() onDelete;

  BookCard(
      {required this.book, required this.onUpdate, required this.onDelete});

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
                'Livro: ${book.name}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Cópia: ${book.copy}'),
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
