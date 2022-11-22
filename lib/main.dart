import 'package:digioteca/app/app_bindings.dart';
import 'package:digioteca/app/routes/routes.dart';
import 'package:digioteca/firebaseconfig.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          authDomain: authDomain,
          storageBucket: storageBucket,
          measurementId: measurementId,
          messagingSenderId: messagingSenderId,
          projectId: projectId));
  AppBindings().dependencies();
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Digioteca',
      debugShowCheckedModeBanner: false,
      textDirection: TextDirection.ltr,
      initialRoute: '/login',
      getPages: AppRoutes.routes,
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal))),
          primaryColorDark: Color(0x00796B),
          primaryColorLight: Color(0xB2DFDB),
          primaryColor: Color(0x009688),
          iconTheme: IconThemeData(
            color: Color(0xFFFFFF),
          ),
          dividerColor: Color(0xBDBDBD),
          scaffoldBackgroundColor: Color(0xFFE4F0E2)),
    );
  }
}
