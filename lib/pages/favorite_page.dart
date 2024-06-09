import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/components/list_tiles/my_all_products_tile.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/components/my_textfield.dart';
import 'package:pharmacy_app/models/all_product_model.dart';
import 'package:pharmacy_app/pages/cart_page.dart';
import 'package:pharmacy_app/pages/product_page.dart';
import 'package:pharmacy_app/services/product_provider.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => FavouritePageState();
}

TextEditingController searchInAllMedicineController = TextEditingController();
double screenHeight = 0.0;
double screenWidth = 0.0;

class FavouritePageState extends State<FavouritePage> {
  List<AllProducts> listAllFavouriteMedicinesData =
      []; // Add this list to store app names
  List<AllProducts> listAllDisplayedFavouriteMedicinesData = [];

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
    String userId = _auth.currentUser!.uid;

    try {
      List<AllProducts> allProducts =
          await allProductsProvider.fetchUserFavoriteMedicine(userId);
      print("fav allProducts: $allProducts");
      setState(() {
        listAllFavouriteMedicinesData = allProducts;
        listAllDisplayedFavouriteMedicinesData =
            List<AllProducts>.from(listAllFavouriteMedicinesData);
      });
    } catch (e) {
      mySnackBar(context, e.toString(), Colors.red);
      throw Exception('Error fetching products: $e');
    }
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        listAllDisplayedFavouriteMedicinesData =
            List<AllProducts>.from(listAllFavouriteMedicinesData);
      } else {
        listAllDisplayedFavouriteMedicinesData = listAllFavouriteMedicinesData
            .where((medicine) => medicine.productName
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void goToViewProduct(AllProducts allProducts) {
    Navigator.push(
      context,
      MyCustomHomePageRoute(
        ProductPage(allProducts: allProducts),
      ),
    );
  }

  void goToCartPage() {
    Navigator.push(
      context,
      MyCustomHomePageRoute(
        CartPage(),
      ),
    );
  }

  void back() {
    Navigator.pop(context);
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
                    width: screenWidth * 0.6,
                    onChange: (value) {},
                    onTap: () {},
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
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
                      onPressed: _getProducts,
                      icon: const Icon(
                        color: Color(0xff272343),
                        Icons.replay_rounded,
                        size: 32,
                      ),
                    ),
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
                    "Favourite Medicines",
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
                              AllProducts allProducts =
                                  listAllDisplayedFavouriteMedicinesData[index];
                              return MyAllProductTile(
                                containerheight: 80,
                                allProducts: allProducts,
                                spaceBetn: screenWidth * 0.03,
                                productDesWidth: screenWidth * 0.5,
                                screenheight: screenHeight,
                                goToViewProduct: goToViewProduct,
                                screenwidth: screenWidth,
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
                                  "No favourites to display",
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
