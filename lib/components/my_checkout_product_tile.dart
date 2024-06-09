import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/models/cart_model.dart';

class MyCheckOutProductTile extends StatelessWidget {
  final CartProduct cartProduct;
  final double spaceBetn;
  final double containerheight;
  final double screenheight;
  final double screenwidth;
  final double productDesWidth;
  const MyCheckOutProductTile({
    super.key,
    required this.cartProduct,
    required this.spaceBetn,
    required this.productDesWidth,
    required this.containerheight,
    required this.screenheight,
    required this.screenwidth,
  });

  @override
  Widget build(BuildContext context) {
    final productName = cartProduct.productName;
    final productType = cartProduct.productTypes;
    final productPrice = cartProduct.productPrice.toString();
    final productQuantity = cartProduct.productAvlQuantity;
    double parsedPrice = double.tryParse(productPrice) ?? 0.0;
    int parsedQuantity = int.tryParse(productQuantity) ?? 0;
    final double productFinalPrice = parsedPrice * parsedQuantity;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            // print("Medicine Name: $productName");
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
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "$productName - ",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.lato(
                                    color: Color(0xff272343),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "$productType",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.lato(
                                    color: Color(0xff272343),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Qty: ${productQuantity}x \u{20B9}$productPrice",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.lato(
                                    color: Color(0xff16698D),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "\u{20B9}$productFinalPrice",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.lato(
                      color: Color(0xff16698D),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: 10,
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
