import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/components/my_textfield.dart';
import 'package:pharmacy_app/pages/cart_page.dart';
import 'package:pharmacy_app/pages/previous_order_page.dart';
import 'package:pharmacy_app/services/product_provider.dart';
import 'package:provider/provider.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => MyOrdersPageState();
}

TextEditingController searchInAllMedicineController = TextEditingController();
double screenHeight = 0.0;
double screenWidth = 0.0;

class MyOrdersPageState extends State<MyOrdersPage> {
  List<String> listAllDisplayedFavouriteMedicinesData = [];

  @override
  void initState() {
    super.initState();
    fetch();
    // fetchOrderHistory();
  }

  @override
  void dispose() {
    super.dispose();
    searchInAllMedicineController.clear();
  }

  void fetch() async {
    final _auth = FirebaseAuth.instance;
    final userId = _auth.currentUser!.uid;
    List<String> userOrderHistory = [];
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    try {
      userOrderHistory =
          await allProductsProvider.fetchUserOrderHistoryList(userId);
      setState(() {
        listAllDisplayedFavouriteMedicinesData = userOrderHistory;
      });
      print("lol $listAllDisplayedFavouriteMedicinesData");
    } catch (e) {
      print("Error fetching order history: $e");
    }
  }

  void _performSearch(String query) {}

  void goToCartPage() {
    Navigator.of(context).push(
      MyCustomHomePageRoute(
        CartPage(),
      ),
    );
  }

  void goToviewPreviousOrderDetails(String orderId) {
    Navigator.of(context).push(
      MyCustomHomePageRoute(
        PreviousOrder(
          orderId: orderId,
        ),
      ),
    );
  }

  void deleteUserOrderHistoryTile(String orderId) async {
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);

    final _auth = FirebaseAuth.instance;
    final userId = _auth.currentUser!.uid;

    try {
      await allProductsProvider.deleteUserOrderHistoryTile(userId, orderId);
      fetch();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16,
                  ),
                  child: MyTextField(
                    controller: searchInAllMedicineController,
                    hintText: "  Search",
                    width: screenWidth * 0.75,
                    onChange: (value) {},
                    onTap: () {},
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 16),
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
                      onPressed: goToCartPage,
                      icon: const Icon(
                        color: Color(0xff272343),
                        Icons.shopping_cart_rounded,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16),
              child: Row(
                children: [
                  Text(
                    "Order History",
                    style: TextStyle(
                      color: Color(0xff272343),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            listAllDisplayedFavouriteMedicinesData.isNotEmpty
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16.0, left: 16, right: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
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
                              String orderId =
                                  listAllDisplayedFavouriteMedicinesData[index];
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: GestureDetector(
                                        onTap: () {
                                          deleteUserOrderHistoryTile(orderId);
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          width: screenWidth * 0.45,
                                          child: Center(
                                            child: Text(
                                              'Delete',
                                              style: GoogleFonts.lato(
                                                color: Color(0xff272343),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      goToviewPreviousOrderDetails(orderId);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Order-ID:",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Color(0xff272343),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            " $orderId",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Color(0xff272343),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0, left: 16, right: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        height: 60,
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 60,
                              color: Colors.white,
                              child: const Center(
                                child: Text(
                                  "No order history to display",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Color(0xff272343),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
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
