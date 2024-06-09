import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/models/all_product_model.dart';

class MyAllProductTile extends StatelessWidget {
  final AllProducts allProducts;
  final double spaceBetn;
  final double containerheight;
  final double screenheight;
  final double screenwidth;
  final double productDesWidth;
  final Function goToViewProduct;
  const MyAllProductTile({
    super.key,
    required this.allProducts,
    required this.spaceBetn,
    required this.productDesWidth,
    required this.containerheight,
    required this.screenheight,
    required this.screenwidth,
    required this.goToViewProduct,
  });

  @override
  Widget build(BuildContext context) {
    final productImageUrl = allProducts.productImageUrl;
    final productName = allProducts.productName;
    final productDes = allProducts.productDescription;
    final productPrice = allProducts.productPrice;
    final productAvailableQuantity = allProducts.productAvlQuantity;
    String noStock = "Nil";

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            // move to Product Page
            goToViewProduct(allProducts);
            print("Medicine Name: $productName");
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: containerheight,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    productImageUrl,
                    height: 90,
                    width: 90,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$productName",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.lato(
                              color: Color(0xff272343),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // SizedBox(
                          //   width: productDesWidth,
                          //   // child: Text(
                          //   //   "$productDes",
                          //   //   style: GoogleFonts.roboto(
                          //   //     color: Color(0xff272343),
                          //   //     fontSize: 14,
                          //   //     fontWeight: FontWeight.w400,
                          //   //   ),
                          //   // ),
                          //   child: Text(
                          //     "$productDes",
                          //     maxLines: 2,
                          //     overflow: TextOverflow.ellipsis,
                          //     style: GoogleFonts.lato(
                          //       color: Color(0xff272343),
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      Container(
                        width: productDesWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 60,
                              child: Text(
                                "\u{20B9}$productPrice",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.lato(
                                  color: Color(0xff16698D),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            productAvailableQuantity > 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Avl Qty: ${productAvailableQuantity.toString()}",
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                          color: Color(0xff00C89A),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Quantity: $noStock",
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.lato(
                                          color: Color(0xffF68685),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    color: Color(0xff272343),
                    Icons.navigate_next_rounded,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
