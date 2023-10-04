//Register
// ignore_for_file: prefer_const_constructors, sort_child_properties_last, must_be_immutable, unused_local_variable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/constant/colors.dart';
import 'package:flower_app/pages/signin.dart';
import 'package:flower_app/widgets/snackBar.dart';
import 'package:flower_app/widgets/decorationOfTextFormField.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final emailAddress = TextEditingController();
  final userName = TextEditingController();
  final jop = TextEditingController();
  final age = TextEditingController();
  bool hiddinPassword = true;

  register() async {
    setState(() {
      isLoading = !isLoading;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress.text,
        password: password.text,
      );

      CollectionReference users = FirebaseFirestore.instance.collection(
          'userss'); // name of yor collection  in your firebase firsestor

      users
          .doc(credential.user?.uid)//'ABC123'
          .set({
            'userName': userName.text,
            'age': age.text,
            'jop': jop.text,
            'email': emailAddress.text,
            'password': password.text,
          })
          .then((value) =>print("User Added") )//showSnackBar(context, "User Added")
          .catchError(
              (error) => print("Failed to add user: $error"));//showSnackBar(context, "Failed to add user: $error")
      //
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.code.toString());
    } catch (e) {
      showSnackBar(context, e.toString());
      // print(e);
    }
    setState(() {
      isLoading = !isLoading;
    });
  }

  bool isLoading = false;
  bool hasMin8Char = false;
  bool isVlidEmail = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasLowercase = false;
  bool hasDigits = false;
  onPasswordChanged(String password) {
    hasMin8Char = false;
    hasUppercase = false;
    hasSpecialCharacters = false;
    hasLowercase = false;
    hasDigits = false;

    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) hasMin8Char = true;
      if (password.contains(RegExp(r'[A-Z]'))) hasUppercase = true;
      if (password.contains(RegExp(r'[a-z]'))) hasLowercase = true;
      if (password.contains(RegExp(r'[0-9]'))) hasDigits = true;
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))
        hasSpecialCharacters = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    password.dispose();
    emailAddress.dispose();
    userName.dispose();
    jop.dispose();
    age.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: appbarGreen,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  TextFormField(
                    controller: userName,
                    maxLength: 30,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Name : ",
                      suffix: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: age,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your age : ",
                      suffix: Icon(Icons.numbers),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: jop,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your jop : ",
                      suffix: Icon(Icons.title),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      return value!.contains(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                          ? null
                          : "Enter a valid email";
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailAddress,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Email : ",
                      suffix: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) {
                      onPasswordChanged(value);
                    },
                    validator: (value) {
                      return value!.length < 8
                          ? "Enter a valid password : at least 8 chracter"
                          : null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: password,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: hiddinPassword,
                    decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Password : ",
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            hiddinPassword = !hiddinPassword;
                          });
                        },
                        icon: hiddinPassword
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasMin8Char ? Colors.green : Colors.white,
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text("has Minimum 8 Characters  "),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasSpecialCharacters
                              ? Colors.green
                              : Colors.white,
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text("has Special Characters @#!|?"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasLowercase ? Colors.green : Colors.white,
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text("has Lowercase "),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasDigits ? Colors.green : Colors.white,
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text("has at least 1 Digits "),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasUppercase ? Colors.green : Colors.white,
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text("has Uppercase "),
                    ],
                  ),
                  !isLoading
                      ? ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                hasDigits &&
                                hasLowercase &&
                                hasMin8Char &&
                                hasSpecialCharacters &&
                                hasUppercase) {
                              await register();
                              if (!mounted) return; // correct
                              showSnackBar(context, "Done...");

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => Signin()),
                                ),
                              );
                            } else {
                              showSnackBar(context, "Error....");
                            }
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 25),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(BTNgreen)),
                        )
                      : CircularProgressIndicator(
                          color: appbarGreen,
                        ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "if you have acount ",
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => Signin())));
                          },
                          child: Text(
                            "sign in",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
