class AllProducts {
  final String productName;
  final String productDescription;
  final double productPrice;
  final String productImageUrl;
  final int productAvlQuantity;
  final List<dynamic> availableTypes;
  final String category;
  final String countryOfOrigin;
  final bool isRecommended;
  final String manufactureName;

  AllProducts({
    required this.availableTypes,
    required this.category,
    required this.countryOfOrigin,
    required this.productDescription,
    required this.productImageUrl,
    required this.isRecommended,
    required this.manufactureName,
    required this.productName,
    required this.productPrice,
    required this.productAvlQuantity,
  });
}
