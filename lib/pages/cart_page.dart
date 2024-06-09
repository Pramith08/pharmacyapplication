import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/my_button.dart';
import 'package:pharmacy_app/components/list_tiles/my_cart_product_tile.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/models/cart_model.dart';
import 'package:pharmacy_app/pages/checkout_page.dart';
import 'package:pharmacy_app/services/product_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => CartPageState();
}

TextEditingController searchInAllMedicineController = TextEditingController();
double screenHeight = 0.0;
double screenWidth = 0.0;

class CartPageState extends State<CartPage> {
  List<CartProduct> listAllFavouriteMedicinesData =
      []; // Add this list to store app names
  List<CartProduct> listAllDisplayedFavouriteMedicinesData = [];

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
      List<CartProduct> allProducts =
          await allProductsProvider.fetchUserCartMedicine(userId);
      setState(() {
        listAllFavouriteMedicinesData = allProducts;
        listAllDisplayedFavouriteMedicinesData =
            List<CartProduct>.from(listAllFavouriteMedicinesData);
      });
    } catch (e) {
      mySnackBar(context, e.toString(), Colors.red);
      throw Exception('Error fetching products: $e');
    }
  }

  void deleteCartProduct(String productId) async {
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);

    final _auth = FirebaseAuth.instance;
    final userId = _auth.currentUser!.uid;

    try {
      await allProductsProvider.deleteUserCartMedicine(userId, productId);
      _getProducts();
    } catch (e) {
      mySnackBar(context, e.toString(), Colors.red);
    }
  }

  void moveToCheckOut() {
    Navigator.push(
      context,
      MyCustomHomePageRoute(
        CheckOutPage(
          listCartProducts: listAllDisplayedFavouriteMedicinesData,
        ),
      ),
    );
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
        child: Stack(
          children: [
            Column(
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
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "My Cart",
                            style: TextStyle(
                              color: Color(0xff272343),
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
                listAllDisplayedFavouriteMedicinesData.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16.0, left: 16, right: 16),
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
                                    listAllDisplayedFavouriteMedicinesData
                                        .length,
                                itemBuilder: (context, index) {
                                  CartProduct cartProduct =
                                      listAllDisplayedFavouriteMedicinesData[
                                          index];
                                  return Slidable(
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: GestureDetector(
                                            onTap: () {
                                              deleteCartProduct(
                                                  cartProduct.productId);
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
                                    child: MyCartProductTile(
                                      containerheight: 80,
                                      cartProduct: cartProduct,
                                      spaceBetn: screenWidth * 0.03,
                                      productDesWidth: screenWidth * 0.45,
                                      screenheight: screenHeight,
                                      screenwidth: screenWidth,
                                      // goToViewProduct: goToViewProduct,
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
                            child: ListView.builder(
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 60,
                                  color: Colors.white,
                                  child: const Center(
                                    child: Text(
                                      "Cart is Empty",
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
            Align(
              alignment: const Alignment(0, 1),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  bottom: 10,
                ),
                child: MyButton(
                  height: 55,
                  width: double.infinity,
                  buttonText: "Confirm Order",
                  onTap: () {
                    if (listAllDisplayedFavouriteMedicinesData.isEmpty) {
                      mySnackBar(context, "Cart is empty", Colors.red);
                      return;
                    } else {}
                    moveToCheckOut();
                  },
                  buttonColor: const Color(0xff272343),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
