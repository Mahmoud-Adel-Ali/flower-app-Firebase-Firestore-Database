// ignore_for_file: curly_braces_in_flow_control_structures, use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/constant/colors.dart';
import 'package:flower_app/widgets/firebse/dateFromFirestor.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('userss');
    final userAuth = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarGreen,
        centerTitle: true,
        title: const Text("Profile"),
        actions: [
          TextButton.icon(
              onPressed: () async {
                GoogleSignIn googleSignin = GoogleSignIn();
                if (await googleSignin.isSignedIn())
                  await googleSignin.disconnect();
                else
                  await FirebaseAuth.instance.signOut();
                // if (!mounted) return;
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                "logout",
                style: TextStyle(
                  color: Colors.white,
                ),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: const Text(
                  "info from firebae auth",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Email : ${userAuth?.email.toString()}",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 15),
              Text(
                // DateFormate("MMM d y").formate(userAuth?.metadata.creationTime)
                // "Created date : ${userAuth?.metadata.creationTime}",
                "Created date : ${DateFormat("MMM d y").format(userAuth!.metadata.creationTime!)}",

                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 15),
              Text(
                "Last sign in date : ${DateFormat("MMM d y").format(userAuth.metadata.lastSignInTime!)}",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 15),
              Center(
                child: TextButton(
                  onPressed: () async{
                    await userAuth.delete();
                      Navigator.pop(context);
                  },
                  child: const Text(
                    "Delete user",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: const Text(
                  "info from firebase firestor",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              GetDataFromFirestor(
                documentId: userAuth.uid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
