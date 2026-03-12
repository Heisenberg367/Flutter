import 'package:flutter/material.dart';
import 'package:flutter_application_b/configs/Routes.dart';
import 'package:flutter_application_b/views/Login%20screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/",
      getPages: routes,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
