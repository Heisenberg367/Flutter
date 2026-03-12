import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/kili.png', height: 120),
                const SizedBox(height: 30),
                TextField(
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Enter username",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                        ))),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Enter password",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
                TextField(
                obscureText: true, // hides the password
               decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: "Enter password",
                filled: true,
                 fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
      ),
    ),
  ),
                const SizedBox(height: 30),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 102, 204),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ]),
                  child: const Text("Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      child: const Text("Sign up",
                          style: TextStyle(color: Colors.blue)),
                      onTap: () {
                        Get.toNamed("/signup");
                      },
                    ),
                    const Spacer(),
                    const Text("Forgot password?"),
                    const Text("Reset password"),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}