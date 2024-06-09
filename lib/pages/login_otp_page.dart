// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:pharmacy_app/components/my_button.dart';
// import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
// import 'package:pharmacy_app/pages/get_newuser_data.dart';
// import 'package:pharmacy_app/pages/home_navigation_page.dart';
// import 'package:pharmacy_app/services/auth_provider.dart';
// import 'package:provider/provider.dart';

// class LoginOtpPage extends StatefulWidget {
//   final String loginMobileNumber;
//   final String verificationId;
//   const LoginOtpPage(
//       {super.key,
//       required this.loginMobileNumber,
//       required this.verificationId});

//   @override
//   State<LoginOtpPage> createState() => _LoginOtpPageState();
// }

// double screenHeight = 0.0;
// double screenWidth = 0.0;

// class _LoginOtpPageState extends State<LoginOtpPage> {
//   late final String loginOtp;
//   void pushBack() {
//     Navigator.pop(context);
//   }

//   void verifyotp(BuildContext context, String otp) {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     authProvider.verifyOtp(
//       context: context,
//       verificationId: widget.verificationId,
//       userOtp: loginOtp,
//       onSuccess: () {
//         authProvider.checkExistingUser().then(
//           (value) async {
//             if (value == true) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => HomeNavigationPage(),
//                 ),
//               );
//             } else {
//               //new user
//               Navigator.push(
//                 context,
//                 MyCustomHomePageRoute(
//                   GetUserDataPage(
//                     userPhoneNumber: widget.loginMobileNumber,
//                   ),
//                 ),
//               );
//             }
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Color(0xffe3f6f5),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Center(
//             child: Stack(
//               children: [
//                 Align(
//                   alignment: Alignment(-1, -0.95),
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.arrow_back_rounded,
//                       size: 32,
//                       color: Color(0xff042A3B),
//                     ),
//                     onPressed: pushBack,
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       height: 200,
//                       width: 200,
//                       color: Colors.white,
//                     ),
//                     Column(
//                       children: [
//                         Text(
//                           "Enter The Verification Code",
//                           style: TextStyle(
//                             color: Color(0xff272343),
//                             fontSize: 24,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),

//                         //One-time passcode sent to your phone number
//                         Text(
//                           "SMS verification code has been sent to your mobile number ******${widget.loginMobileNumber.substring(widget.loginMobileNumber.length - 4)}",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Color(0xff272343),
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.02,
//                         ),
//                         OtpTextField(
//                           numberOfFields: 6,
//                           fieldWidth: screenWidth * 0.13,
//                           filled: true,
//                           alignment: Alignment.center,
//                           autoFocus: true,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           keyboardType: TextInputType.number,
//                           hasCustomInputDecoration: true,
//                           onSubmit: (value) {
//                             loginOtp = value;
//                           },
//                           decoration: const InputDecoration(
//                             fillColor: Colors.white,
//                             filled: true,
//                             counterStyle: TextStyle(
//                               color: Color(0xff042A3B),
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 width: 2,
//                                 color: Colors.transparent,
//                               ),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(10),
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 width: 2,
//                                 color: Color(0xFF3E3F43),
//                               ),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(8),
//                               ),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 width: 2,
//                                 color: Colors.red,
//                               ),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(5),
//                               ),
//                             ),
//                             hintText: "0",
//                             hintStyle: TextStyle(
//                               color: Color(0xFF666B70),
//                               fontSize: 20,
//                             ),
//                           ),
//                           showFieldAsBox: true,
//                           textStyle: const TextStyle(
//                             color: Color(0xff042A3B),
//                             fontSize: 20,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(
//                           height: screenHeight * 0.02,
//                         ),
//                         MyButton(
//                           height: 55,
//                           width: double.infinity,
//                           buttonText: "Submit",
//                           onTap: () {
//                             print("$loginOtp");
//                             verifyotp(context, loginOtp);
//                           },
//                           buttonColor: const Color(0xff042A3B),
//                         ),
//                       ],
//                     ),

//                     // TextButton(
//                     //   style: TextButton.styleFrom(
//                     //     fixedSize: const Size(240, 40),
//                     //   ),
//                     //   onPressed: () {
//                     //     pushToNewUserPage();
//                     //   },
//                     //   child: Row(
//                     //     mainAxisAlignment: MainAxisAlignment.center,
//                     //     children: [
//                     //       Text(
//                     //         "New User? ",
//                     //         style: TextStyle(
//                     //           color: Color(0xff2D2D33),
//                     //           fontSize: 16,
//                     //           fontWeight: FontWeight.w500,
//                     //         ),
//                     //       ),
//                     //       Text(
//                     //         "SIGN UP",
//                     //         style: TextStyle(
//                     //           color: Color(0xff6246ea),
//                     //           fontSize: 16,
//                     //           fontWeight: FontWeight.w700,
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
