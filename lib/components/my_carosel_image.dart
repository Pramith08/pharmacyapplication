import 'package:flutter/material.dart';

class MyCaroselImage extends StatelessWidget {
  final String imageUrl;
  const MyCaroselImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
