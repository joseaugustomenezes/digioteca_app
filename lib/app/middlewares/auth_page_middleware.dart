import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthPageMiddleware extends GetMiddleware {
  @override
  userAlreadyLoggedIn() {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.userChanges().listen((user) {
      if (user != null) {
        Get.toNamed('/home');
      }
    });
  }
}
