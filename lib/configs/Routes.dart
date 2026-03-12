import 'package:flutter_application_b/views/Login%20screen.dart';
import 'package:flutter_application_b/views/signup.dart';
import 'package:flutter_application_b/views/homescreen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

var routes = [
  GetPage(name: "/", page: () => const LoginScreen()),
  GetPage(name: "/signup", page: () => const Signupscreen()),
  GetPage(name: "/homescreen", page: () => const Homescreen()),
];




