import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/models/user_model.dart';
import 'package:pharmacy_app/pages/cart_page.dart';
import 'package:pharmacy_app/services/auth_gate.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void userLogout() async {
    final _auth = FirebaseAuth.instance;
    try {
      _auth.signOut();
      // Navigate to your login screen or any other desired screen after logout
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    } catch (e) {
      print("Error signing out: $e");
      // Handle any errors if necessary
    }
  }

  UserModel? userDetails;

  @override
  void initState() {
    super.initState();
    // Load user details when the page initializes
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    // Retrieve user details from Firebase using the logged-in user's UID
    String uid = FirebaseAuth.instance.currentUser!.uid;
    UserModel? user = await retrieveUserDataFromFirebase(uid);
    setState(() {
      userDetails = user;
    });
  }

  Future<UserModel?> retrieveUserDataFromFirebase(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(uid)
          .collection("UserDetails")
          .doc(uid)
          .get();

      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      } else {
        // Document does not exist
        return null;
      }
    } catch (e) {
      print("Error retrieving user data: $e");
      return null;
    }
  }

  void goToCartPage() {
    Navigator.of(context).push(
      MyCustomHomePageRoute(
        CartPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe3f6f5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      Text(
                        "User Details/Settings",
                        // widget.allProducts.productName,
                        style: GoogleFonts.lato(
                          color: const Color(0xff272343),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: IconButton(
                          onPressed: goToCartPage,
                          icon: Icon(
                            color: Color(0xff272343),
                            Icons.shopping_cart_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 55,
                        width: 55,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: IconButton(
                          onPressed: userLogout,
                          icon: const Icon(
                            color: Color(0xff272343),
                            Icons.power_settings_new_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: userDetails == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      width: double.infinity,
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(8),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            scrollbarTheme: ScrollbarThemeData(
                              thumbColor: MaterialStateProperty.all(
                                  const Color(0xff272343)),
                            ),
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 3,
                            radius: const Radius.circular(50),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    // height: 45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Name:",
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              userDetails!.name,
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    // height: 45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Email Id:",
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              userDetails!.email,
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    // height: 45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Mobile Number:",
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              userDetails!.mobileNumber,
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    // height: 45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Address:",
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              userDetails!.address,
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    // height: 45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Age:",
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              userDetails!.age,
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    // height: 45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Gender:",
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              userDetails!.gender,
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    // height: 45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "User Date Of Birth:",
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              userDetails!.dateOfBirth,
                                              // widget.allProducts.productName,
                                              style: GoogleFonts.lato(
                                                color: const Color(0xff272343),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
