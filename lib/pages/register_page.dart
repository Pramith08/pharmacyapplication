import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/my_button.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';

import 'package:pharmacy_app/components/my_pass_textfield.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/components/my_textfield.dart';
import 'package:pharmacy_app/pages/get_newuser_data.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

double screenHeight = 0.0;
double screenWidth = 0.0;

TextEditingController _registerEmailController = TextEditingController();
TextEditingController _registerPassController = TextEditingController();
TextEditingController _confirmRegisterPassController = TextEditingController();

class _RegisterPageState extends State<RegisterPage> {
  void back() {
    Navigator.pop(context);
  }

  // void pushToGetUserDataPage() {
  //   Navigator.of(context).pushReplacement(
  //     MyCustomHomePageRoute(
  //       GetUserDataPage(
  //         userEmailId: _registerEmailController.text.trim(),
  //       ),
  //     ),
  //   );
  // }

  Future<void> newUserRegister(BuildContext context) async {
    // showDialog(
    //   context: context,
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator(
    //       color: Color(0xFFC3BBBB),
    //     ),
    //   ),
    // );
    try {
      if (_registerEmailController.text.isEmpty &&
          _registerPassController.text.isEmpty &&
          _confirmRegisterPassController.text.isEmpty) {
        mySnackBar(context, "Fill Your Details", Colors.red);
        // Navigator.pop(context);
        return;
      }
      if (_registerEmailController.text.isEmpty &&
          _registerPassController.text.isEmpty) {
        mySnackBar(context, "Enter Your Email and Password", Colors.red);
        // Navigator.pop(context);
        return;
      }
      if (_confirmRegisterPassController.text.isEmpty) {
        mySnackBar(context, "Enter Your Password Again", Colors.red);
        // Navigator.pop(context);
        return;
      }

      if (_registerEmailController.text.isEmpty) {
        mySnackBar(context, "Enter Your Email", Colors.red);
        // Navigator.pop(context);
        return;
      }
      if (_registerPassController.text.isEmpty) {
        mySnackBar(context, "Enter Your Password", Colors.red);
        // Navigator.pop(context);
        return;
      }
      if (_registerPassController.text != _confirmRegisterPassController.text) {
        mySnackBar(context, "Your Password Doesn't Match", Colors.red);
        _confirmRegisterPassController.clear();
        // Navigator.pop(context);
        return;
      }

      Navigator.of(context).pushReplacement(
        MyCustomHomePageRoute(
          GetUserDataPage(
            userEmailId: _registerEmailController.text.trim(),
            userPassword: _registerPassController.text.trim(),
          ),
        ),
      );
      _registerEmailController.clear();
      _registerPassController.clear();
      _confirmRegisterPassController.clear();

      // Navigator.pop(context);
      // back();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        mySnackBar(context, "Invalid Email", Colors.red);
        _registerEmailController.clear();
        _registerPassController.clear();
        _confirmRegisterPassController.clear();
        // Navigator.pop(context);
        return;
      } else if (e.code == 'invalid-credential') {
        mySnackBar(context, "Invalid Credential", Colors.red);
        // Navigator.pop(context);
        return;
      } else if (e.code == 'network-request-failed') {
        mySnackBar(context, "Check Your Network Connection", Colors.red);
        // Navigator.pop(context);
        return;
      } else if (e.code == 'weak-password') {
        mySnackBar(context, "Please Enter A Strong Password", Colors.red);
        // Navigator.pop(context);
        return;
      } else if (e.code == 'email-already-in-use') {
        mySnackBar(context, "UserID Already Exist", Colors.red);
        // Navigator.pop(context);
        return;
      }

      mySnackBar(context, e.toString(), Colors.red);
      Navigator.pop(context);
    } catch (e) {
      mySnackBar(context, e.toString(), Colors.red);
      Navigator.pop(context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffe3f6f5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          // height: 300,
                          width: 300,
                          // color: Colors.amber,
                          child: Center(
                            child: Image.asset("assets/images/image2.jpg"),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        Column(
                          children: [
                            Text(
                              "Enter Your Details to Register",
                              style: GoogleFonts.lato(
                                color: Color(0xff272343),
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            // MyTextField(
                            //   controller: _registerEmailController,
                            //   hintText: "  Name",
                            //   width: double.infinity,
                            //   onChange: (value) {},
                            //   keyboardType: TextInputType.phone,
                            //   onTap: () {},
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            MyTextField(
                              controller: _registerEmailController,
                              hintText: "  Email Id",
                              width: double.infinity,
                              onChange: (value) {},
                              keyboardType: TextInputType.text,
                              onTap: () {},
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyPasswordTextField(
                              controller: _registerPassController,
                              hintText: "  Password",
                              width: double.infinity,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            MyPasswordTextField(
                              controller: _confirmRegisterPassController,
                              hintText: "  Confirm Password",
                              width: double.infinity,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MyButton(
                              height: 55,
                              width: double.infinity,
                              buttonText: "Register",
                              onTap: () {
                                newUserRegister(context);
                                // pushToGetUserDataPage();
                              },
                              buttonColor: const Color(0xff042A3B),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(-1, -1),
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: IconButton(
                      onPressed: back,
                      icon: const Icon(
                        color: Color(0xff272343),
                        Icons.arrow_back_rounded,
                        size: 32,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
