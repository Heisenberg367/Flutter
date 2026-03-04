import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/Pasted image.png'),
                SizedBox(height: 30),
                TextField(decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter username", prefixIcon: Icon(Icons.person))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Enter password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
                TextField(decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Enter password", prefixIcon: Icon(Icons.lock))),
                SizedBox(height: 30),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Color.fromARGB(255, 3, 79, 140)),
                  child: Text("Login", style: TextStyle(color: Color.fromARGB(255, 234, 19, 19), fontWeight: FontWeight.w900, fontSize: 25)),
                ),
                Row(children: [
                  Text("Don't have an account?"),
                  SizedBox(width: 5),
                  Text("Sign up", style: TextStyle(color: Colors.tealAccent),), // <-- comma after "Sign up" & Colors uppercase
                  Spacer(),
                  Text("Forgot password?"),
                  Text("Reset password"),  
                ],)
              ],
            ),
          ),
        ),
      ),
    ),
  );
}