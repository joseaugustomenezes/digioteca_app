import 'package:digioteca/app/modules/home/submodules/books/books_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../shared/widgets/loading.dart';

class RegisterOrEditBook extends GetView<BooksController> {
  static final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final FocusNode _name = FocusNode();
  final FocusNode _copy = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
              '${controller.isBookBeingAdded.value ? 'Adicionar livro' : 'Atualizar livro'}'),
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
                        controller: controller.bookName.value,
                        decoration: InputDecoration(
                            hintText: 'nome',
                            errorText: controller.bookNameError.value == '' ||
                                    controller.bookNameError.value.isEmpty
                                ? null
                                : controller.bookNameError.value),
                        focusNode: _name,
                        onChanged: (_) => controller
                            .validadeName(controller.bookName.value.text),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_copy);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.bookCopy.value,
                        decoration: InputDecoration(
                            hintText: 'cópia',
                            errorText: controller.bookCopyError.value == '' ||
                                    controller.bookCopyError.value.isEmpty
                                ? null
                                : controller.bookCopyError.value),
                        focusNode: _copy,
                        onChanged: (_) => controller
                            .validadeBookCopy(controller.bookCopy.value.text),
                      ),
                      SizedBox(
                        height: 20,
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
                  if (controller.isBookBeingAdded.value) {
                    if (controller.shouldEnableButton()) {
                      _form.currentState!.save();
                      controller.addBook();
                    }
                  } else {
                    if (controller.shouldEnableButton()) {
                      _form.currentState!.save();
                      controller.updateSelectedBook();
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
                  child: controller.isAddingBook.value ||
                          controller.isUpdatingBook.value
                      ? Loading()
                      : Text(
                          '${controller.isBookBeingAdded.value ? 'Adicionar' : 'Atualizar'}',
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
