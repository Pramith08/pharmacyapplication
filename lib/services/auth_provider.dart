import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/models/user_model.dart';
import 'package:pharmacy_app/pages/login_otp_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // String? _uid;
  // String get uid => _uid!;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  // void signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
  //   try {
  //     await _auth.verifyPhoneNumber(
  //         phoneNumber: phoneNumber,
  //         verificationCompleted:
  //             (PhoneAuthCredential phoneAuthCredential) async {
  //           await _auth.signInWithCredential(phoneAuthCredential);
  //         },
  //         verificationFailed: (error) {
  //           throw Exception(error.message);
  //         },
  //         codeSent: (verificationId, forceResendingToken) {
  //           Navigator.push(
  //             context,
  //             MyCustomHomePageRoute(
  //               LoginOtpPage(
  //                   loginMobileNumber: phoneNumber,
  //                   verificationId: verificationId),
  //             ),
  //           );
  //         },
  //         codeAutoRetrievalTimeout: ((verificationId) {}));
  //   } on FirebaseAuth catch (e) {
  //     mySnackBar(context, e.toString(), Colors.red);
  //   }
  // }

  void signout() {
    _auth.signOut();
  }

  Future<UserCredential> createNewUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return userCredential;
    } catch (e) {
      // Handle exceptions
      throw e;
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    //add loading
    notifyListeners();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _auth.signInWithCredential(credential)).user;

      if (user != null) {
        // _uid = user.uid;
        onSuccess();
      } else {
        //stop loading
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      mySnackBar(context, e.toString(), Colors.red);
    }
  }

  // Future<bool> checkExistingUser() async {
  //   DocumentSnapshot snapshot =
  //       await _firestore.collection("users").doc(_uid).get();
  //   if (snapshot.exists) {
  //     print("User Exist");
  //     return true;
  //   } else {
  //     print("New User");
  //     return false;
  //   }
  // }

  Future<void> saveDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required String uid,
    required Function onSuccess,
  }) async {
    notifyListeners();
    try {
      _userModel = userModel;

      await _firestore
          .collection("users")
          .doc(uid)
          .collection("UserDetails")
          .doc(uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
      });
    } catch (e) {
      mySnackBar(context, e.toString(), Colors.red);
    }
  }

  Future<List<String>> getMedicineCategories() async {
    List<String> categoriesList = [];

    QuerySnapshot querySnapshot =
        await _firestore.collection("medicines").orderBy("category").get();

    querySnapshot.docs.forEach((doc) {
      String category = doc['category'];
      if (!categoriesList.contains(category)) {
        categoriesList.add(category);
      }
    });

    return categoriesList;
  }
}
