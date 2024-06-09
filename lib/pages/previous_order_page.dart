import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/my_button.dart';
import 'package:pharmacy_app/components/my_checkout_product_tile.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/models/cart_model.dart';
import 'package:pharmacy_app/services/product_provider.dart';
import 'package:provider/provider.dart';

class PreviousOrder extends StatefulWidget {
  final String orderId;
  const PreviousOrder({super.key, required this.orderId});

  @override
  State<PreviousOrder> createState() => PreviousOrderState();
}

TextEditingController searchInAllMedicineController = TextEditingController();
double screenHeight = 0.0;
double screenWidth = 0.0;

class PreviousOrderState extends State<PreviousOrder> {
  List<CartProduct> listAllDisplayedFavouriteMedicinesData = [];

  List<CartProduct> listAllFavouriteMedicinesData = [];

  String finalTotal = "";

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  void dispose() {
    super.dispose();
    searchInAllMedicineController.clear();
  }

  void _getProducts() async {
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);

    final _auth = FirebaseAuth.instance;
    final userId = _auth.currentUser!.uid;
    try {
      List<CartProduct> allProducts = await allProductsProvider
          .fetchUserOrderHistoryDetails(userId, widget.orderId);
      setState(() {
        listAllFavouriteMedicinesData = allProducts;
        listAllDisplayedFavouriteMedicinesData =
            List<CartProduct>.from(listAllFavouriteMedicinesData);
      });
      sumPrices();
    } catch (e) {
      mySnackBar(context, e.toString(), Colors.red);
      throw Exception('Error fetching products: $e');
    }
  }

  void sumPrices() {
    double total = 0.0;
    print("sumtotal");

    for (var i = 0; i < listAllDisplayedFavouriteMedicinesData.length; i++) {
      CartProduct cartProduct = listAllDisplayedFavouriteMedicinesData[i];
      final String price = cartProduct.productPrice;
      final String quantity = cartProduct.productAvlQuantity;

      print("Price: $price, Quantity: $quantity");

      // Convert price and quantity to numeric values
      double parsedPrice = double.tryParse(price) ?? 0.0;
      int parsedQuantity = int.tryParse(quantity) ?? 0;

      // Multiply the price by the quantity
      double tempPrice = parsedPrice * parsedQuantity;

      // Add the result to the total
      total += tempPrice;
    }

    print("Total: $total");

    setState(() {
      finalTotal = total.toStringAsFixed(2);
    });
  }

  // void fetch() async {
  //   final _auth = FirebaseAuth.instance;
  //   final userId = _auth.currentUser!.uid;
  //   List<String> userOrderHistory = [];
  //   try {
  //     userOrderHistory = await fetchUserOrderHistoryList(userId);
  //     setState(() {
  //       listAllDisplayedFavouriteMedicinesData = userOrderHistory;
  //     });
  //     print("lol $listAllDisplayedFavouriteMedicinesData");
  //   } catch (e) {
  //     print("Error fetching order history: $e");
  //   }
  // }

  // Future<List<String>> fetchUserOrderHistoryList(String userId) async {
  //   List<String> userOrderHistory = [];
  //   final allProductsProvider =
  //       Provider.of<ProductProvider>(context, listen: false);
  //   try {
  //     userOrderHistory =
  //         await allProductsProvider.fetchUserOrderHistoryList(userId);

  //     return userOrderHistory;
  //   } catch (e) {
  //     print("Fetch User Order History Error: $e");
  //     return userOrderHistory;
  //   }
  // }

  // void _performSearch(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       listSearchOrderHistory = List<String>.from(listAllOrderHistory);
  //     } else {
  //       // listSearchOrderHistory = listAllOrderHistory
  //       //     .where((medicine) => medicine.productName
  //       //         .toLowerCase()
  //       //         .contains(query.toLowerCase()))
  //       //     .toList();
  //     }
  //   });
  // }
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                      onPressed: back,
                      icon: const Icon(
                        color: Color(0xff272343),
                        Icons.arrow_back_rounded,
                        size: 32,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "ID: ${widget.orderId}",
                    style: GoogleFonts.lato(
                      color: Color(0xff272343),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              const Row(
                children: [
                  Text(
                    "Order Summary",
                    style: TextStyle(
                      color: Color(0xff272343),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              listAllDisplayedFavouriteMedicinesData.isNotEmpty
                  ? Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          height: screenHeight * 0.78,
                          child: ListView.builder(
                            itemCount:
                                listAllDisplayedFavouriteMedicinesData.length,
                            itemBuilder: (context, index) {
                              CartProduct cartProduct =
                                  listAllDisplayedFavouriteMedicinesData[index];
                              return MyCheckOutProductTile(
                                containerheight: 80,
                                cartProduct: cartProduct,
                                spaceBetn: screenWidth * 0.03,
                                productDesWidth: screenWidth * 0.45,
                                screenheight: screenHeight,
                                screenwidth: screenWidth,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          height: 60,
                          child: Center(child: CircularProgressIndicator())),
                    ),
              listAllDisplayedFavouriteMedicinesData.isNotEmpty
                  ? Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16,
                          bottom: 10,
                          top: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Total: ",
                                    style: GoogleFonts.lato(
                                      color: Color(0xff272343),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "\u{20B9}$finalTotal",
                                    style: GoogleFonts.lato(
                                      color: Color(0xff16698D),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MyButton(
                              height: 55,
                              width: screenWidth * 0.4,
                              buttonText: "Place Order",
                              onTap: () {
                                // mySnackBar(
                                //     context, "Order Placed Successfully", Colors.green);
                                // pushToHomeNavigationPage();
                              },
                              buttonColor: const Color(0xff272343),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
