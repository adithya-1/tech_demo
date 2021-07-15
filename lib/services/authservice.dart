import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tech_demo/pages/homePage.dart';
import 'package:tech_demo/pages/loginPage.dart';
import 'package:tech_demo/services/errorHandler.dart';

class AuthService {
  //Determine if the user is authenticated.
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage(
              auth: AuthService(),
              userId: FirebaseAuth.instance.currentUser!.uid,
            );
          } else {
            return LoginPage(
              auth: AuthService(),
            );
          }
        });
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //Sign In
  signIn(String email, String password, context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((val) {
      print('signed in');
    }).catchError((e) {
      ErrorHandler().errorDialog(context, e);
    });
  }

  Future<User> getCurrentUser() async {
    User user = FirebaseAuth.instance.currentUser!;
    return user;
  }

  //fb signin

}
