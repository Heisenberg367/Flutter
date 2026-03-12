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
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/Pasted image.png'),
                const SizedBox(height: 30),
                const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter username",
                        prefixIcon: Icon(Icons.person))),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Enter password",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
                const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter password",
                        prefixIcon: Icon(Icons.lock))),
                const SizedBox(height: 30),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 3, 79, 140)),
                  child: const Text("Login",
                      style: TextStyle(
                          color: Color.fromARGB(255, 234, 19, 19),
                          fontWeight: FontWeight.w900,
                          fontSize: 25)),
                ),
                Row(
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
