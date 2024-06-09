import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/models/cart_model.dart';

class MyCartProductTile extends StatelessWidget {
  final CartProduct cartProduct;
  final double spaceBetn;
  final double containerheight;
  final double screenheight;
  final double screenwidth;
  final double productDesWidth;
  const MyCartProductTile({
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
    final productImageUrl = cartProduct.productImageUrl;
    final productName = cartProduct.productName;

    final productPrice = cartProduct.productPrice.toString();

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
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
                            Text(
                              "${cartProduct.productTypes}",
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
                              "Quantity: ${cartProduct.productAvlQuantity}",
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
                        Text(
                          "\u{20B9}$productPrice",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.lato(
                            color: Color(0xff16698D),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    color: Color(0xff272343),
                    Icons.navigate_before_rounded,
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
