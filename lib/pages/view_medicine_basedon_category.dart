import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/components/list_tiles/my_all_products_tile.dart';
import 'package:pharmacy_app/components/my_custom_home_page_transition.dart';
import 'package:pharmacy_app/components/my_snack_bar.dart';
import 'package:pharmacy_app/components/my_textfield.dart';
import 'package:pharmacy_app/models/all_product_model.dart';
import 'package:pharmacy_app/pages/product_page.dart';
import 'package:pharmacy_app/services/product_provider.dart';
import 'package:provider/provider.dart';

class ViewMedicineBasedOnCategory extends StatefulWidget {
  final String medicineCategory;
  const ViewMedicineBasedOnCategory({
    super.key,
    required this.medicineCategory,
  });

  @override
  State<ViewMedicineBasedOnCategory> createState() =>
      _ViewMedicineBasedOnCategoryState();
}

TextEditingController searchInAllMedicineController = TextEditingController();
double screenHeight = 0.0;
double screenWidth = 0.0;

class _ViewMedicineBasedOnCategoryState
    extends State<ViewMedicineBasedOnCategory> {
  List<AllProducts> listAllMedicinesData = [];
  List<AllProducts> listAllDisplayedMedicinesData = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    getProducts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    searchInAllMedicineController.clear();
    _focusNode.dispose();
    super.dispose();
  }

  void getProducts() async {
    final allProductsProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      List<AllProducts> listAll = await allProductsProvider
          .fetchProductBasedOnCategoryFromDatabase(widget.medicineCategory);

      setState(() {
        listAllMedicinesData = listAll;
        listAllDisplayedMedicinesData =
            List<AllProducts>.from(listAllMedicinesData);
      });
      print("All products $listAll");
    } catch (e) {
      mySnackBar(context, e.toString(), Colors.red);
      throw Exception('Error fetching products: $e');
    }
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        listAllDisplayedMedicinesData =
            List<AllProducts>.from(listAllMedicinesData);
      } else {
        listAllDisplayedMedicinesData = listAllMedicinesData
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
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
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
                  Container(
                    height: 55,
                    width: screenWidth * 0.75,
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextField(
                      onTap: null,
                      onChanged: (value) {
                        _performSearch(searchInAllMedicineController.text);
                      },
                      keyboardType: TextInputType.text,
                      focusNode: _focusNode,
                      cursorColor: const Color(0xFF042A3B),
                      style: GoogleFonts.lato(
                        color: Color(0xff272343),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      controller: searchInAllMedicineController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xFF3E3F43),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.red,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        hintText: "  Search",
                        hintStyle: GoogleFonts.lato(
                          color: Color(0xFF666B70),
                          fontSize: 15,
                        ),
                        labelStyle: GoogleFonts.lato(
                          color: Color(0xFF666B70),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16),
              child: Row(
                children: [
                  Text(
                    "Medicines under ${widget.medicineCategory}",
                    style: GoogleFonts.lato(
                      color: Color(0xff272343),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            listAllDisplayedMedicinesData.isNotEmpty
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
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              scrollbarTheme: ScrollbarThemeData(
                                thumbColor: MaterialStateProperty.all(
                                    Color(0xff272343)),
                              ),
                            ),
                            child: Scrollbar(
                              thumbVisibility: true,
                              thickness: 3,
                              radius: Radius.circular(50),
                              child: ListView.builder(
                                itemCount: listAllDisplayedMedicinesData.length,
                                itemBuilder: (context, index) {
                                  AllProducts allProducts =
                                      listAllDisplayedMedicinesData[index];
                                  return MyAllProductTile(
                                    containerheight: 80,
                                    allProducts: allProducts,
                                    spaceBetn: screenWidth * 0.03,
                                    productDesWidth: screenWidth * 0.45,
                                    screenheight: screenHeight,
                                    screenwidth: screenWidth,
                                    goToViewProduct: goToViewProduct,
                                  );
                                },
                              ),
                            ),
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
                                  "No medicine",
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
