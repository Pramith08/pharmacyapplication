// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:pharmacy_app/components/my_button.dart';
// import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
// import 'package:pharmacy_app/components/my_icon_button.dart';
// import 'package:pharmacy_app/components/my_snack_bar.dart';
// import 'package:pharmacy_app/pages/get_newuser_data.dart';
// import 'package:pharmacy_app/pages/home_page.dart';
// import 'package:pharmacy_app/services/auth_provider.dart';
// import 'package:provider/provider.dart';

// class RegisterOtpPage extends StatefulWidget {
//   final String loginMobileNumber;
//   final String verificationId;
//   const RegisterOtpPage({
//     super.key,
//     required this.loginMobileNumber,
//     required this.verificationId,
//   });

//   @override
//   State<RegisterOtpPage> createState() => _RegisterOtpPageState();
// }

// double screenHeight = 0.0;
// double screenWidth = 0.0;
// // TextEditingController _registerOtpController = TextEditingController();

// class _RegisterOtpPageState extends State<RegisterOtpPage> {
//   late final String registerOtp; // needs to be fixed
//   void pushBack() {
//     Navigator.pop(context);
//   }

//   void verifyotp(BuildContext context, String otp) {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     authProvider.verifyOtp(
//       context: context,
//       verificationId: widget.verificationId,
//       userOtp: registerOtp,
//       onSuccess: () {
//         authProvider.checkExistingUser().then(
//           (value) async {
//             if (value == true) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => HomePage(),
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
//     final number = widget.loginMobileNumber;
//     return Scaffold(
//       backgroundColor: const Color(0xffEBF9FF),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Stack(
//             children: [
//               Align(
//                 alignment: const Alignment(-1, -1),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: screenHeight * 0.013,
//                     ),
//                     MyIconButton(
//                       icon: const Icon(
//                         Icons.arrow_back_ios_sharp,
//                         color: Colors.white,
//                       ),
//                       buttonColor: const Color(0xff042A3B),
//                       buttonHeight: 50,
//                       buttonWidth: 50,
//                       onPressed: pushBack,
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: screenHeight * 0.02,
//                   ),
//                   const Text(
//                     "Register OTP",
//                     style: TextStyle(
//                       color: Color(0xff042A3B),
//                       fontSize: 30,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                   SizedBox(
//                     height: screenHeight * 0.005,
//                   ),
//                   Text(
//                     "Code sent to +91 $number",
//                     style: TextStyle(
//                       color: Color(0xff042A3B),
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(
//                     height: screenHeight * 0.03,
//                   ),
//                   const Row(
//                     children: [
//                       SizedBox(
//                         width: 3,
//                       ),
//                       Text(
//                         "Enter the OTP",
//                         style: TextStyle(
//                           color: Color(0xff042A3B),
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: screenHeight * 0.0015,
//                   ),
//                   OtpTextField(
//                     numberOfFields: 6,
//                     fieldWidth: 55,
//                     filled: true,
//                     alignment: Alignment.center,
//                     autoFocus: true,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     keyboardType: TextInputType.number,
//                     hasCustomInputDecoration: true,
//                     onSubmit: (value) {
//                       registerOtp = value;
//                     },
//                     decoration: const InputDecoration(
//                       fillColor: Colors.white,
//                       filled: true,
//                       counterStyle: TextStyle(
//                         color: Color(0xff042A3B),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2,
//                           color: Colors.transparent,
//                         ),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10),
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2,
//                           color: Color(0xFF3E3F43),
//                         ),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8),
//                         ),
//                       ),
//                       errorBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 2,
//                           color: Colors.red,
//                         ),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(5),
//                         ),
//                       ),
//                       hintText: "0",
//                       hintStyle: TextStyle(
//                         color: Color(0xFF666B70),
//                         fontSize: 20,
//                       ),
//                     ),
//                     showFieldAsBox: true,
//                     textStyle: const TextStyle(
//                       color: Color(0xff042A3B),
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(
//                     height: screenHeight * 0.02,
//                   ),
//                   MyButton(
//                     height: 55,
//                     width: double.infinity,
//                     buttonText: "Submit",
//                     onTap: () {
//                       print(registerOtp);
//                       print(widget.verificationId);
//                       verifyotp(context, registerOtp);
//                     },
//                     buttonColor: const Color(0xff042A3B),
//                   ),
//                   SizedBox(
//                     height: screenHeight * 0.01,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
