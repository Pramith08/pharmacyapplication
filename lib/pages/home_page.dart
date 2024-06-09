import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/list_tiles/my_all_products_tile.dart';
import 'package:pharmacy_app/components/my_carosel_image.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/models/all_product_model.dart';
import 'package:pharmacy_app/pages/cart_page.dart';
import 'package:pharmacy_app/pages/product_page.dart';
import 'package:pharmacy_app/pages/view_all_medicines_page.dart';
import 'package:pharmacy_app/pages/view_medicine_basedon_category.dart';
import 'package:pharmacy_app/services/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

TextEditingController searchMedicineController = TextEditingController();
double screenHeight = 0.0;
double screenWidth = 0.0;

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int activeIndex = 0;
  // List<dynamic> listShopProducts = [];

  List<dynamic> categorielist = [];

  List<AllProducts> listAllMedicinesData =
      []; // Add this list to store app names
  List<AllProducts> listAllDisplayedMedicinesData = [];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _getProducts();
    getAllCategories(context);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _getProducts() async {
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      List<AllProducts> allProducts =
          await allProductsProvider.fetchRecommendedProductsFromDatabase();

      print("Recommended allProduct---- $allProducts");
      setState(() {
        listAllMedicinesData = allProducts;
        listAllDisplayedMedicinesData =
            List<AllProducts>.from(listAllMedicinesData);
      });
    } catch (e) {
      // mySnackBar(context, e.toString(), Colors.red);
      // throw Exception('Error fetching products: $e');
    }
  }

  void goToViewAllMedicinePage() {
    Navigator.push(
      context,
      MyCustomHomePageRoute(
        const ViewAllMedicinePage(),
      ),
    );
  }

  void goToViewMedicineBasedOnCategory(String medicineCategory) {
    Navigator.push(
      context,
      MyCustomHomePageRoute(
        ViewMedicineBasedOnCategory(
          medicineCategory: medicineCategory,
        ),
      ),
    );
  }

  void getAllCategories(BuildContext context) async {
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);
    try {
      categorielist = await allProductsProvider.fetchMedicineCategories();
    } catch (error) {
      // Handle error
      print('Error fetching categories: $error');
    }
  }

  void goToCartPage() {
    Navigator.push(
      context,
      MyCustomHomePageRoute(
        CartPage(),
      ),
    );
  }

  void goToViewProduct(AllProducts allProducts) {
    Navigator.push(
      context,
      MyCustomHomePageRoute(
        ProductPage(allProducts: allProducts),
      ),
    );
  }

  final List<Map<String, dynamic>> medicineCategories = [
    {
      "name": "Tablets",
      "image": "assets/images/tablets.svg",
    },
    {
      "name": "Capsules",
      "image": "assets/images/capsules.svg",
    },
    {
      "name": "Liquids",
      "image": "assets/images/liquids.svg",
    },
    {
      "name": "Drops",
      "image": "assets/images/drops.svg",
    },
    {
      "name": "Injections",
      "image": "assets/images/syringe.svg",
    },
    {
      "name": "Inhalers",
      "image": "assets/images/inhalers.svg",
    },
  ];

  final carouselBanners = [
    "assets/images/image1.jpg",
    "assets/images/image2.jpg",
    "assets/images/image3.jpg",
  ];

  Color getColorFromNumber(int number) {
    switch (number) {
      case 1:
        return Color(0xffFED0C0);
      case 2:
        return Color(0xffF68685);
      case 3:
        return Color(0xffB3E0DD);
      case 4:
        return Color(0xffEEE8DC);
      default:
        return Colors.white; // Default color for unknown numbers
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffe3f6f5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //search textfield
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 16,
                    ),
                    child: GestureDetector(
                      onTap: goToViewAllMedicinePage,
                      child: Container(
                        height: 55,
                        width: screenWidth * 0.75,
                        decoration: const BoxDecoration(
                          color: Color(0xffFFFFFF),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "Search",
                                style: GoogleFonts.lato(
                                  color: Color(0xFF666B70),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // child: MyTextField(
                    //   controller: searchMedicineController,
                    //   hintText: "  Search",
                    //   width: screenWidth * 0.75,
                    //   onChange: (value) {},
                    //   onTap: goToViewAllMedicinePage,
                    //   keyboardType: TextInputType.text,
                    // ),
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
                height: screenHeight * 0.03,
              ),

              //carousel banners
              CarouselSlider.builder(
                itemCount: carouselBanners.length,
                itemBuilder: (context, index, realIndex) {
                  final imagePath = carouselBanners[index];
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyCaroselImage(imageUrl: imagePath),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: screenHeight * 0.3,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    if (mounted) {
                      setState(() {
                        activeIndex = index;
                      });
                    }
                  },
                ),
              ),

              //page indicator for carousel banners
              AnimatedSmoothIndicator(
                activeIndex: activeIndex,
                count: carouselBanners.length,
                effect: const ExpandingDotsEffect(
                  dotColor: Colors.white,
                  activeDotColor: Color(0xff272343),
                  dotHeight: 5,
                  dotWidth: 15,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shop by category",
                      style: GoogleFonts.lato(
                        color: Color(0xff272343),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),

              //hotizontal list of categories
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: medicineCategories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      String categoryText = medicineCategories[index]["name"];
                      final String svgImagePath =
                          medicineCategories[index]["image"];

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                goToViewMedicineBasedOnCategory(categoryText);
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SvgPicture.asset(
                                      color: const Color(0xff042A3B),
                                      svgImagePath,
                                      theme: const SvgTheme(
                                        xHeight: 10,
                                        currentColor: Color(0xff272343),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            categoryText,
                            style: GoogleFonts.lato(
                              color: Color(0xff272343),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              //recommended to buy text
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recommended to buy",
                      style: GoogleFonts.lato(
                        color: Color(0xff272343),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              goToViewAllMedicinePage();
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 30,
                              // width: 100,
                              alignment: Alignment.center,
                              child: Text(
                                "View all",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  color: Color(0xff272343),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),

              //recommened to buy products listview
              listAllDisplayedMedicinesData.isNotEmpty
                  ? Column(
                      children: List.generate(
                        listAllDisplayedMedicinesData.length,
                        (index) {
                          AllProducts allProducts =
                              listAllDisplayedMedicinesData[index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: MyAllProductTile(
                              containerheight: 80,
                              allProducts: allProducts,
                              spaceBetn: screenWidth * 0.03,
                              productDesWidth: screenWidth * 0.5,
                              screenheight: screenHeight,
                              goToViewProduct: goToViewProduct,
                              screenwidth: screenWidth,
                            ),
                          );
                        },
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
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 60,
                              color: Colors.white,
                              child: const Center(
                                child: Text(
                                  "No recommended products",
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

              SizedBox(
                height: screenHeight * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
