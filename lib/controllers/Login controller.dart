import 'package:get/get.dart';

class Logincontoller extends GetxController {
  var username;
  var password;
  var isLoggedIn = false.obs;

  Login(user, pass) {
    username = user;
    password = pass;
    if (username == "admin" && password == "Fidelz") {
      return true;
    } else {
      return false;
    }
  }
  togglePassword(){
    isLoggedIn.value = !isLoggedIn.value;
  }
}
