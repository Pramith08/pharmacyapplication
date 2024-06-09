import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/my_button.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/models/all_product_model.dart';
import 'package:pharmacy_app/pages/cart_page.dart';
import 'package:pharmacy_app/services/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductPage extends StatefulWidget {
  final AllProducts allProducts;
  const ProductPage({
    super.key,
    required this.allProducts,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

double screenHeight = 0.0;
double screenWidth = 0.0;

class _ProductPageState extends State<ProductPage> {
  String chosenQuantity = "0";
  String dropdownValue = "";

  bool isFavorite = false;
  String userId = "";

  int maxQuantity = 10;

  void checkFavoriteStatus() async {
    //create a seperate function in authProvider to get user-id
    final _auth = FirebaseAuth.instance;
    final String uid = _auth.currentUser!.uid;
    setState(() {
      userId = uid;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .collection('userFavouriteMedicines')
          .doc(widget.allProducts.productName)
          .get();
      print("$snapshot");

      print("initail isfav: $isFavorite");
      if (snapshot.exists) {
        setState(() {
          isFavorite = true;
        });
      } else {
        setState(() {
          isFavorite = snapshot.exists;
        });
      }

      print("post isFav: $isFavorite");
    } catch (e) {
      print("Error checking favorite status: $e");
    }
  }

  void toggleFavoriteStatus() async {
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    try {
      if (isFavorite) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('userFavouriteMedicines')
            .doc(widget.allProducts.productName)
            .delete();
      } else {
        await allProductsProvider.updateUserFavoriteMedicine(
            userId, widget.allProducts);
      }

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      print("Error toggling favorite status: $e");
    }
  }

  void uploadProductToCart() async {
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    try {
      if (chosenQuantity == "0") {
        mySnackBar(context, "Increase the quantity", Colors.red);
        return;
      } else {
        await allProductsProvider.updateUserCartMedicine(
          userId,
          widget.allProducts,
          dropdownValue,
          chosenQuantity,
        );
      }
      back();
      mySnackBar(context, "Product added to cart successfully", Colors.green);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.allProducts.availableTypes[0];
    checkFavoriteStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void back() {
    Navigator.pop(context);
  }

  void goToCartPage() {
    Navigator.push(
      context,
      MyCustomHomePageRoute(
        CartPage(),
      ),
    );
  }

  int activeIndex = 0;

  List<String> list = <String>[
    '10 Tablets',
    '20 Tablets',
    '40 Tablets',
    '50 Tablets',
  ];

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                          onPressed: back,
                          icon: const Icon(
                            color: Color(0xff272343),
                            Icons.arrow_back_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Product Details",
                        // widget.allProducts.productName,
                        style: GoogleFonts.lato(
                          color: const Color(0xff272343),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  //favorite icon
                  //if medicine added to favorite, show favorite_rounded icon else show favorite_outline_rounded icon
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
                          onPressed: toggleFavoriteStatus,
                          icon: Icon(
                            color: Color(0xff272343),
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
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
                          onPressed: goToCartPage,
                          icon: Icon(
                            color: Color(0xff272343),
                            Icons.shopping_cart_rounded,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xffe3f6f5), // addcolor
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                width: double.infinity,
                height: screenHeight * 0.35,
                // color: Color(0xffe3f6f5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/Dolo650.png",
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AnimatedSmoothIndicator(
                        activeIndex: activeIndex,
                        count: list.length,
                        effect: const ExpandingDotsEffect(
                          dotColor: Colors.white,
                          activeDotColor: Color(0xff272343),
                          dotHeight: 5,
                          dotWidth: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                // bottom: 16,
                left: 30,
                right: 30,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.allProducts.productName}",
                        // widget.allProducts.productName,
                        style: GoogleFonts.lato(
                          color: const Color(0xff272343),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "\u{20B9}${widget.allProducts.productPrice.toString()}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          color: const Color(0xff272343),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white, // addcolor
                          border: Border.all(
                            color: Colors.white, // addcolor
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        width: screenWidth * 0.5,
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: DropdownButton(
                              value: dropdownValue,
                              underline: Container(
                                height: 1,
                                color: Colors.transparent,
                              ),
                              icon: const Icon(Icons.arrow_drop_down_sharp),
                              style: const TextStyle(color: Color(0xff272343)),
                              items: widget.allProducts.availableTypes
                                  .map<DropdownMenuItem<dynamic>>(
                                (dynamic item) {
                                  // (String item) {
                                  return DropdownMenuItem(
                                    alignment: Alignment.center,
                                    value: item,
                                    child: Text(
                                      // textAlign: TextAlign.center,
                                      item,
                                      style: GoogleFonts.lato(
                                        color: const Color(0xff272343),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  dropdownValue = value.toString();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white, // addcolor
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                int quantity = int.parse(chosenQuantity);
                                if (quantity == 0) {
                                  mySnackBar(
                                      context, "Invalid quantity", Colors.red);
                                  return;
                                } else {}
                                setState(() {
                                  chosenQuantity = (quantity - 1).toString();
                                });
                              },
                              icon: const Icon(
                                color: Color(0xff272343),
                                Icons.remove_rounded,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            chosenQuantity,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              color: const Color(0xff272343),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                              color: Colors.white, // addcolor
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  int quantity = int.parse(chosenQuantity);
                                  if (quantity == 10) {
                                    mySnackBar(context, "Max quantity reached",
                                        Colors.red);
                                    return;
                                  } else {}
                                  setState(() {
                                    chosenQuantity = (quantity + 1).toString();
                                  });
                                },
                                icon: const Icon(
                                  color: Color(0xff272343),
                                  Icons.add_rounded,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                color: Colors.transparent,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xffe3f6f5),
                    // borderRadius: BorderRadius.all(
                    //   Radius.circular(8),
                    // ),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      scrollbarTheme: ScrollbarThemeData(
                        thumbColor:
                            MaterialStateProperty.all(const Color(0xff272343)),
                      ),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 3,
                      radius: const Radius.circular(50),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // const SizedBox(
                            //   height: 15,
                            // ),
                            Text(
                              "Description",
                              // widget.allProducts.productName,
                              style: GoogleFonts.lato(
                                color: const Color(0xff272343),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            // const SizedBox(
                            //   height: 3,
                            // ),
                            Text(
                              "${widget.allProducts.productDescription}",
                              // widget.allProducts.productName,
                              style: GoogleFonts.lato(
                                color: const Color(0xff272343),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Category",
                              // widget.allProducts.productName,
                              style: GoogleFonts.lato(
                                color: const Color(0xff272343),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            // const SizedBox(
                            //   height: 3,
                            // ),
                            Text(
                              "${widget.allProducts.category}",
                              // widget.allProducts.productName,
                              style: GoogleFonts.lato(
                                color: const Color(0xff272343),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Manufacture/Marketer",
                              // widget.allProducts.productName,
                              style: GoogleFonts.lato(
                                color: const Color(0xff272343),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            // const SizedBox(
                            //   height: 3,
                            // ),
                            Text(
                              "${widget.allProducts.manufactureName}",
                              // widget.allProducts.productName,
                              style: GoogleFonts.lato(
                                color: const Color(0xff272343),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Country of origin",
                              // widget.allProducts.productName,
                              style: GoogleFonts.lato(
                                color: const Color(0xff272343),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            // const SizedBox(
                            //   height: 3,
                            // ),
                            Text(
                              "${widget.allProducts.countryOfOrigin}",
                              // widget.allProducts.productName,
                              style: GoogleFonts.lato(
                                color: const Color(0xff272343),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                color: Colors.transparent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16,
                bottom: 16,
              ),
              child: MyButton(
                height: 55,
                width: double.infinity,
                buttonText: "Add To Cart",
                onTap: () {
                  uploadProductToCart();
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
