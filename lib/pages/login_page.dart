import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/my_button.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/components/my_pass_textfield.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/components/my_textfield.dart';
import 'package:pharmacy_app/pages/home_navigation_page.dart';
import 'package:pharmacy_app/pages/register_page.dart';
import 'package:pharmacy_app/services/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

double screenHeight = 0.0;
double screenWidth = 0.0;
TextEditingController _loginEmailController = TextEditingController();
TextEditingController _loginPasswordController = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  void pustToNewUser() {
    Navigator.push(
      context,
      MyCustomHomePageRoute(
        RegisterPage(),
      ),
    );
  }

  Future<void> userLogin(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFC3BBBB),
        ),
      ),
    );
    try {
      if (_loginEmailController.text.isEmpty &&
          _loginPasswordController.text.isEmpty) {
        mySnackBar(context, "Enter Your Email and Password", Colors.red);
        Navigator.pop(context);
        return;
      }
      if (_loginEmailController.text.isEmpty) {
        mySnackBar(context, "Enter Your Email", Colors.red);
        Navigator.pop(context);
        return;
      }
      if (_loginPasswordController.text.isEmpty) {
        mySnackBar(context, "Enter Your Password", Colors.red);
        Navigator.pop(context);
        return;
      }
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _loginEmailController.text,
        password: _loginPasswordController.text,
      );

      Navigator.pop(context);
      if (userCredential.user != null) {
        // String userId = userCredential.user!.uid;

        Navigator.of(context)
            .pushReplacement(MyCustomHomePageRoute(HomeNavigationPage()));
        _loginEmailController.clear();
        _loginPasswordController.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        mySnackBar(context, "User Not Found", Colors.red);
        Navigator.pop(context);
        return;
      } else if (e.code == 'wrong-password') {
        mySnackBar(context, "Wrong Password", Colors.red);
        Navigator.pop(context);
        return;
      } else if (e.code == 'invalid-email') {
        mySnackBar(context, "Invalid Credentials", Colors.red);
        Navigator.pop(context);
        return;
      } else if (e.code == 'invalid-credential') {
        mySnackBar(context, "Wrong Password", Colors.red);
        Navigator.pop(context);
        return;
      } else if (e.code == 'network-request-failed') {
        mySnackBar(context, "Check Your Network Connection", Colors.red);
        Navigator.pop(context);
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 300,
                    child: Center(
                      child: Image.asset(
                          "assets/images/image1.jpg"), //new logo here
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Column(
                    children: [
                      Text(
                        "Enter Your Login Credentials",
                        style: GoogleFonts.lato(
                          color: Color(0xff272343),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MyTextField(
                        controller: _loginEmailController,
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
                        controller: _loginPasswordController,
                        hintText: "  Password",
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MyButton(
                        height: 55,
                        width: double.infinity,
                        buttonText: "Login",
                        onTap: () {
                          userLogin(context);
                        },
                        buttonColor: const Color(0xff042A3B),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: const Size(240, 40),
                        ),
                        onPressed: () {
                          pustToNewUser();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "New User? ",
                              style: GoogleFonts.lato(
                                color: Color(0xff2D2D33),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              " SIGN UP",
                              style: GoogleFonts.lato(
                                color: Color(0xff6246ea),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
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
