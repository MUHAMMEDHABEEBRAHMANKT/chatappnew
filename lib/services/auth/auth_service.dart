import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  // instunce of firebase
  final FirebaseAuth authServices = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//get current user
  User? getCurrentUser() {
    return authServices.currentUser;
  }

  //log in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, password) async {
    try {
      //sing in user
      if (email == "" || password == "") {
        throw Exception("Please Enter The Details!");
      } else {
        UserCredential userCredential = await authServices
            .signInWithEmailAndPassword(email: email, password: password);
        //save user info if dosen't alredy exist
        _firestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': email,
          },
        );
        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  ///sign out

  Future<void> signOut() async {
    return await authServices.signOut();
  }

  //sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await authServices
          .createUserWithEmailAndPassword(email: email, password: password);
      //save user info in a spearete document
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
