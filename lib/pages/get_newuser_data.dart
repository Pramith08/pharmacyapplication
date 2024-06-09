import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/my_button.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/components/my_textfield.dart';
import 'package:pharmacy_app/models/user_model.dart';
import 'package:pharmacy_app/pages/home_navigation_page.dart';
import 'package:pharmacy_app/services/auth_gate.dart';
import 'package:pharmacy_app/services/auth_provider.dart';
import 'package:provider/provider.dart';

class GetUserDataPage extends StatefulWidget {
  final String userEmailId;
  final String userPassword;
  const GetUserDataPage({
    super.key,
    required this.userEmailId,
    required this.userPassword,
  });

  @override
  State<GetUserDataPage> createState() => _GetUserDataPageState();
}

double screenHeight = 0.0;
double screenWidth = 0.0;

class _GetUserDataPageState extends State<GetUserDataPage> {
  final _newUserNameController = TextEditingController();
  final _newUserMobileNumberController = TextEditingController();
  final _newUserAddressController = TextEditingController();
  final _newUserAgeController = TextEditingController();
  final _newUserGenderController = TextEditingController();
  final _newUserDOBController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _newUserNameController.dispose();
    _newUserMobileNumberController.dispose();
    _newUserAddressController.dispose();
    _newUserAgeController.dispose();
    _newUserGenderController.dispose();
    _newUserDOBController.dispose();
    super.dispose();
  }

  Future<void> saveUserDetailsAndPushToHomePage() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final registerUserCredential = await ap.createNewUserWithEmailAndPassword(
        widget.userEmailId, widget.userPassword);

    if (registerUserCredential.user != null) {
      final userId = registerUserCredential.user?.uid;
      storeUserData(userId!);
    }
  }

  void storeUserData(String uid) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    // final userId = ap.uid;

    UserModel userModel = UserModel(
      name: _newUserNameController.text.trim(),
      email: widget.userEmailId,
      mobileNumber: "+91${_newUserMobileNumberController.text.trim()}",
      address: _newUserAddressController.text.trim(),
      age: _newUserAgeController.text.trim(),
      gender: _newUserGenderController.text.trim(),
      dateOfBirth: _newUserDOBController.text.trim(),
      userCreatedDateandTime: DateTime.now().toString(),
      userId: uid,
    );
    if (_newUserNameController.text.isNotEmpty &&
        _newUserMobileNumberController.text.isNotEmpty &&
        _newUserAddressController.text.isNotEmpty &&
        _newUserAgeController.text.isNotEmpty &&
        _newUserGenderController.text.isNotEmpty &&
        _newUserDOBController.text.isNotEmpty) {
      ap.saveDataToFirebase(
          context: context,
          userModel: userModel,
          uid: uid,
          onSuccess: () {
            // mySnackBar(context, "success", Colors.green);
            print("--------------Success--------------------");
          });
      Navigator.pushReplacement(
        context,
        MyCustomHomePageRoute(
          AuthGate(),
        ),
      );
    } else {
      mySnackBar(context, "enter the fields", Colors.red);
      return;
    }
  }

  void back() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffe3f6f5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        "Fill Your Details",
                        style: GoogleFonts.lato(
                          color: const Color(0xff272343),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MyTextField(
                          controller: _newUserNameController,
                          hintText: "  Name",
                          width: double.infinity,
                          onChange: (value) {},
                          keyboardType: TextInputType.text,
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                  child: Text(
                                "\u{002B} 91 ",
                                style: GoogleFonts.lato(
                                  color: const Color(0xff272343),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                            ),
                            MyTextField(
                              controller: _newUserMobileNumberController,
                              hintText: "  Mobile Number",
                              width: screenWidth * 0.7,
                              onChange: (value) {},
                              keyboardType: TextInputType.phone,
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _newUserAddressController,
                          hintText: "  Address Line 1",
                          width: double.infinity,
                          onChange: (value) {},
                          keyboardType: TextInputType.text,
                          onTap: () {},
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _newUserAgeController,
                          hintText: "  Age",
                          width: double.infinity,
                          onChange: (value) {},
                          keyboardType: TextInputType.phone,
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _newUserGenderController,
                          hintText: "  Gender",
                          width: double.infinity,
                          onChange: (value) {},
                          keyboardType: TextInputType.text,
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: _newUserDOBController,
                          hintText: "  Date Of Birth",
                          width: double.infinity,
                          onChange: (value) {},
                          keyboardType: TextInputType.text,
                          onTap: () {},
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: MyButton(
                height: 55,
                width: double.infinity,
                buttonText: "Submit",
                onTap: () {
                  saveUserDetailsAndPushToHomePage();
                },
                buttonColor: const Color(0xff272343),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
