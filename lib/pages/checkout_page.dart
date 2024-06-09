import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/my_button.dart';
import 'package:pharmacy_app/components/my_checkout_product_tile.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/models/cart_model.dart';
import 'package:pharmacy_app/services/auth_gate.dart';
import 'package:pharmacy_app/services/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckOutPage extends StatefulWidget {
  final List<CartProduct> listCartProducts;
  const CheckOutPage({
    super.key,
    required this.listCartProducts,
  });

  @override
  State<CheckOutPage> createState() => CheckOutPageState();
}

double screenHeight = 0.0;
double screenWidth = 0.0;

class CheckOutPageState extends State<CheckOutPage> {
  List<CartProduct> listAllFavouriteMedicinesData =
      []; // Add this list to store app names

  String finalTotal = "";
  String orderId = "";

  @override
  void initState() {
    super.initState();
    print("${widget.listCartProducts.length}");
    sumPrices();
    getOrderId();
  }

  void back() {
    Navigator.pop(context);
  }

  void pushToHomeNavigationPage() {
    Navigator.of(context).pushReplacement(
      MyCustomHomePageRoute(
        const AuthGate(),
      ),
    );
  }

  void sumPrices() {
    double total = 0.0;
    for (var i = 0; i < widget.listCartProducts.length; i++) {
      CartProduct cartProduct = widget.listCartProducts[i];
      final String price = cartProduct.productPrice;
      final String quantity = cartProduct.productAvlQuantity;
      double parsedPrice = double.tryParse(price) ?? 0.0;
      int parsedQuantity = int.tryParse(quantity) ?? 0;
      double tempPrice = parsedPrice * parsedQuantity;
      total += tempPrice;
    }
    setState(() {
      finalTotal = total.toStringAsFixed(2);
    });
  }

  String generateOrderID() {
    DateTime now = DateTime.now();

    String firstDatePart =
        "${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year}";
    String secondDatePart =
        "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}";

    String letters = '';
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();

    for (int i = 0; i < 3; i++) {
      letters += alphabet[random.nextInt(alphabet.length)];
      letters += random.nextInt(10).toString();
    }

    String orderID = '$firstDatePart$letters$secondDatePart';

    return orderID;
  }

  void getOrderId() {
    final String tempOrderId = generateOrderID();
    setState(() {
      orderId = tempOrderId;
    });
  }

  String getActualMessage(List<CartProduct> orderSummary) {
    String actualMessage = '';

    for (int i = 0; i < orderSummary.length; i++) {
      var product = orderSummary[i];
      int productQuantity = int.tryParse(product.productAvlQuantity) ?? 0;
      double productPrice = double.tryParse(product.productPrice) ?? 0.0;
      double productTotal = productQuantity * productPrice;

      actualMessage += 'Product Number ${i + 1}:\n' +
          '    - Product Name: ${product.productName}\n' +
          '    - Product Type: ${product.productTypes}\n' +
          '    - Quantity: ${productQuantity}\n' +
          '    - Price: \u{20B9}${productPrice.toStringAsFixed(2)}\n' +
          '    - Product Total Price : \u{20B9}${productTotal.toStringAsFixed(2)}\n\n';
    }

    return actualMessage;
  }

  void openWhatsappAndSendOrder(
    String finalOrderid,
    String dateAndTime,
    List<CartProduct> orderSymmary,
    String total,
  ) async {
    var number = "+918925403024";
    String header =
        "Order ID: $finalOrderid\nOrder placed on: $dateAndTime\n\nOrder Details:\n\n";

    String actualMessage = getActualMessage(orderSymmary);
    String footer = "\nFinal Total: \u{20B9}$total";
    String finalMessage = "$header+$actualMessage+$footer";

    var urlAndriod = "whatsapp://send?phone=$number&text=$finalMessage";
    var urlIOS = "";
    try {
      await launch(urlAndriod);
    } catch (e) {
      print(e);
    }
  }

  void reduceMedicineAvailableQuantity() {}

  void placeUserOrder() {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    openWhatsappAndSendOrder(
        orderId, formattedDate, widget.listCartProducts, finalTotal);
    print("order placed");
  }

  Future<void> updateOrderHistory(
      List<CartProduct> listCartProducts, String orderId) async {
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    print("updating.....");
    final _auth = FirebaseAuth.instance;
    final userId = _auth.currentUser!.uid;
    try {
      await allProductsProvider.updateOrderHistory(
        userId,
        listCartProducts,
        orderId,
      );
      print("Order history updated successfully.");
    } catch (e) {
      print("Update Order History Error: $e");
      throw Exception('Error updating order history: $e');
    }
  }

  void clearUserCart() async {
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);

    final _auth = FirebaseAuth.instance;
    final userId = _auth.currentUser!.uid;
    try {
      await allProductsProvider.clearUserCart(userId);
      Navigator.of(context).pushReplacement(
        MyCustomHomePageRoute(
          const AuthGate(),
        ),
      );
      print("cart cleared");
    } catch (e) {
      mySnackBar(context, e.toString(), Colors.red);
    }
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
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
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
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Checkout / Order Summary",
                        style: GoogleFonts.lato(
                          color: const Color(0xff272343),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Text(
              "Order Id: $orderId ",
              style: GoogleFonts.lato(
                color: const Color(0xff272343),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
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
                      itemCount: widget.listCartProducts.length,
                      itemBuilder: (context, index) {
                        CartProduct cartProduct =
                            widget.listCartProducts[index];
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
              ),
            ),
            Container(
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            "Total: ",
                            style: GoogleFonts.lato(
                              color: const Color(0xff272343),
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "\u{20B9}$finalTotal",
                            style: GoogleFonts.lato(
                              color: const Color(0xff16698D),
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
                        //place order - send message
                        placeUserOrder();

                        //create a dialogue box to confirm the order placement

                        //update order history
                        updateOrderHistory(widget.listCartProducts, orderId);

                        //clear user cart
                        clearUserCart();
                      },
                      buttonColor: const Color(0xff272343),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
