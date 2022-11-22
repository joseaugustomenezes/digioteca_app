import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digioteca/app/modules/home/submodules/books/books_model.dart';
import 'package:digioteca/app/modules/home/submodules/books/books_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BooksController extends GetxController {
  BooksRepository _repository = Get.find();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<TextEditingController> bookName = TextEditingController().obs;
  Rx<TextEditingController> bookCopy = TextEditingController().obs;
  RxString bookNameError = ''.obs;
  RxString bookCopyError = ''.obs;
  RxBool isFechtingBooks = false.obs;
  RxBool isAddingBook = false.obs;
  RxBool isDeletingBook = false.obs;
  RxBool isUpdatingBook = false.obs;
  RxBool isBookBeingAdded = false.obs;

  Rx<List<BookModel>?> _books = Rx<List<BookModel>?>(null);
  List<BookModel>? get books => _books.value;
  set books(List<BookModel>? books) => _books.value = books;

  Rx<String?> _selectedBookId = Rx<String?>(null);
  String? get selectedBookId => _selectedBookId.value;
  set selectedBookId(String? selectedBookId) =>
      _selectedBookId.value = selectedBookId;

  Future fetchBooksFromCurrentUser() async {
    try {
      isFechtingBooks.value = true;
      books = await _repository.fetchBooksFromCurrentUser();
      books!.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      print(e);
    } finally {
      isFechtingBooks.value = false;
    }
  }

  String validadeName(String value) {
    final bool isValid =
        RegExp(r'^[a-zA-ZáàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ ]+$').hasMatch(value);

    if (!isValid) {
      return bookNameError.value = 'Nome inválido!';
    } else {
      return bookNameError.value = '';
    }
  }

  Future addBook() async {
    try {
      isAddingBook.value = true;
      await _db
          .collection("users")
          .doc("${_auth.currentUser!.uid}")
          .collection("livros")
          .doc()
          .set({
        "copia": int.parse(bookCopy.value.text),
        "nome": bookName.value.text
      });
      books = await _repository.fetchBooksFromCurrentUser();
      books!.sort((a, b) => a.name.compareTo(b.name));
      Get.back();
    } catch (e) {
      print(e);
    } finally {
      isAddingBook.value = false;
    }
  }

  Future updateSelectedBook() async {
    try {
      isUpdatingBook.value = true;
      await _db
          .collection("users")
          .doc("${_auth.currentUser!.uid}")
          .collection("livros")
          .doc(selectedBookId)
          .set({
        "copia": int.parse(bookCopy.value.text),
        "nome": bookName.value.text
      });
      books = await _repository.fetchBooksFromCurrentUser();
      books!.sort((a, b) => a.name.compareTo(b.name));
      Get.back();
    } catch (e) {
      print(e);
    } finally {
      isUpdatingBook.value = false;
    }
  }

  bool shouldEnableButton() {
    if (bookName.value.text.isEmpty ||
        bookCopy.value.text.isEmpty ||
        bookNameError.value.isNotEmpty ||
        bookCopyError.value.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future deleteBook() async {
    try {
      isDeletingBook.value = true;
      await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("livros")
          .doc(selectedBookId)
          .delete();
      books = await _repository.fetchBooksFromCurrentUser();
      books!.sort((a, b) => a.name.compareTo(b.name));
      Get.until((route) => Get.isOverlaysClosed);
      Get.back();
    } catch (e) {
      print(e);
    } finally {
      isDeletingBook.value = false;
    }
  }

  void onAddBookButtonPress() {
    isBookBeingAdded.value = true;
    bookName.value.text = '';
    bookCopy.value.text = '';
    bookNameError.value = '';
    bookNameError.value = '';
  }

  void onEditBookButtonPress(BookModel book) {
    isBookBeingAdded.value = false;
    selectedBookId = book.id;
    bookName.value.text = book.name;
    bookCopy.value.text = book.copy.toString();
  }

  String validadeBookCopy(String copy) {
    final bool isCopyValid = RegExp(r'[0-99]').hasMatch(copy.toString());
    if (!isCopyValid) {
      return bookCopyError.value = 'Valor inválido!';
    } else {
      return bookCopyError.value = '';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBooksFromCurrentUser();
    bookName.value.addListener(() {
      bookName.refresh();
    });
    bookCopy.value.addListener(() {
      bookCopy.refresh();
    });
  }
}
