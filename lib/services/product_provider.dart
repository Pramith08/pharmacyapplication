import 'package:flutter/material.dart';
import 'package:pharmacy_app/models/all_product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmacy_app/models/cart_model.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AllProducts>> fetchAllProductFromDatabase() async {
    final List<AllProducts> listProducts = [];
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('medicines').get();

      // _listProducts.clear();
      querySnapshot.docs.forEach((doc) {
        String productName = doc['name'];
        String productDescription = doc['description'];
        double productPrice = doc['price'];
        int productQuantity = doc['quantity'];
        String productCategory = doc['category'];
        String productCountryOfOrigin = doc['countryOfOrigin'];
        bool productIsRecommended = doc['isRecommended'];
        String productManufactureName = doc['manufactureName'];
        List<dynamic> productAvailableTypes = doc['availableTypes'];

        AllProducts allProducts = AllProducts(
          availableTypes: productAvailableTypes,
          category: productCategory,
          countryOfOrigin: productCountryOfOrigin,
          productDescription: productDescription,
          productImageUrl: "assets/images/Dolo650.png",
          isRecommended: productIsRecommended,
          manufactureName: productManufactureName,
          productName: productName,
          productPrice: productPrice,
          productAvlQuantity: productQuantity,
        );

        listProducts.add(allProducts);
      });

      return listProducts;
    } catch (e) {
      print("Fetch All Products Error: $e");
      return listProducts;
    }
  }

  Future<List<AllProducts>> fetchProductBasedOnCategoryFromDatabase(
      String category) async {
    final List<AllProducts> listProducts = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('medicines')
          .where('category', isEqualTo: category)
          .get();

      // _listProducts.clear();
      querySnapshot.docs.forEach((doc) {
        String productName = doc['name'];
        String productDescription = doc['description'];
        double productPrice = doc['price'];
        int productQuantity = doc['quantity'];
        String productCategory = doc['category'];
        String productCountryOfOrigin = doc['countryOfOrigin'];
        bool productIsRecommended = doc['isRecommended'];
        String productManufactureName = doc['manufactureName'];
        List<dynamic> productAvailableTypes = doc['availableTypes'];

        AllProducts allProducts = AllProducts(
          availableTypes: productAvailableTypes,
          category: productCategory,
          countryOfOrigin: productCountryOfOrigin,
          productDescription: productDescription,
          productImageUrl: "assets/images/Dolo650.png",
          isRecommended: productIsRecommended,
          manufactureName: productManufactureName,
          productName: productName,
          productPrice: productPrice,
          productAvlQuantity: productQuantity,
        );

        listProducts.add(allProducts);
      });

      return listProducts;
    } catch (e) {
      print("Fetch All Products Error: $e");
      return listProducts;
    }
  }

  Future<List<String>> fetchMedicineCategories() async {
    List<String> categoriesList = [];
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('medicines').get();

      querySnapshot.docs.forEach((doc) {
        String category = doc['category'];
        if (!categoriesList.contains(category)) {
          categoriesList.add(category);
        }
      });

      return categoriesList;
    } catch (e) {
      print("Fetch Medicine Categories Error: $e");
      return categoriesList;
    }
  }

  Future<List<AllProducts>> fetchRecommendedProductsFromDatabase() async {
    final List<AllProducts> recommendedProducts = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('medicines')
          .where('isRecommended', isEqualTo: true)
          .get();

      querySnapshot.docs.forEach((doc) {
        String productName = doc['name'];
        String productDescription = doc['description'];
        double productPrice = doc['price'];
        int productQuantity = doc['quantity'];
        String productCategory = doc['category'];
        String productCountryOfOrigin = doc['countryOfOrigin'];
        bool productIsRecommended = doc['isRecommended'];
        String productManufactureName = doc['manufactureName'];
        List<dynamic> productAvailableTypes = doc['availableTypes'];

        AllProducts product = AllProducts(
          availableTypes: productAvailableTypes,
          category: productCategory,
          countryOfOrigin: productCountryOfOrigin,
          productDescription: productDescription,
          productImageUrl: "assets/images/Dolo650.png",
          isRecommended: productIsRecommended,
          manufactureName: productManufactureName,
          productName: productName,
          productPrice: productPrice,
          productAvlQuantity: productQuantity,
        );

        recommendedProducts.add(product);
      });

      return recommendedProducts;
    } catch (e) {
      print("Fetch Recommended Products Error: $e");
      return recommendedProducts;
    }
  }

  Future<void> updateUserFavoriteMedicine(
      String userId, AllProducts allProducts) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('userFavouriteMedicines')
          .doc(allProducts.productName)
          .set({
        'availableTypes': allProducts.availableTypes,
        'category': allProducts.category,
        'countryOfOrigin': allProducts.countryOfOrigin,
        'description': allProducts.productDescription,
        'imageUrl': allProducts.productImageUrl,
        'isRecommended': allProducts.isRecommended,
        'manufactureName': allProducts.manufactureName,
        'price': allProducts.productPrice,
        'quantity': allProducts.productAvlQuantity,
        'name': allProducts.productName,
      });
    } catch (e) {
      print("userFavoriteMEdicine error: $e");
    }
  }

  Future<List<AllProducts>> fetchUserFavoriteMedicine(String userId) async {
    final List<AllProducts> userFavoriteProduct = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('userFavouriteMedicines')
          .get();

      querySnapshot.docs.forEach((doc) {
        String productName = doc['name'];
        String productDescription = doc['description'];
        double productPrice = doc['price'];
        int productQuantity = doc['quantity'];
        String productCategory = doc['category'];
        String productCountryOfOrigin = doc['countryOfOrigin'];
        bool productIsRecommended = doc['isRecommended'];
        String productManufactureName = doc['manufactureName'];
        List<dynamic> productAvailableTypes = doc['availableTypes'];

        AllProducts product = AllProducts(
          availableTypes: productAvailableTypes,
          category: productCategory,
          countryOfOrigin: productCountryOfOrigin,
          productDescription: productDescription,
          productImageUrl: "assets/images/Dolo650.png",
          isRecommended: productIsRecommended,
          manufactureName: productManufactureName,
          productName: productName,
          productPrice: productPrice,
          productAvlQuantity: productQuantity,
        );

        userFavoriteProduct.add(product);
      });

      return userFavoriteProduct;
    } catch (e) {
      print("Fetch Recommended Products Error: $e");
      return userFavoriteProduct;
    }
  }

  Future<void> updateUserCartMedicine(String userId, AllProducts allProducts,
      String dropValue, String selectedQuantity) async {
    String noSpaces = dropValue.replaceAll(' ', '');
    String drop_values = noSpaces.replaceAll('/', "");
    String productPrice = allProducts.productPrice.toString().trim();
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('userCart')
          .doc("${allProducts.productName}_$drop_values")
          .set({
        'medicineTypes': dropValue,
        'category': allProducts.category,
        'countryOfOrigin': allProducts.countryOfOrigin,
        'description': allProducts.productDescription,
        'imageUrl': allProducts.productImageUrl,
        'manufactureName': allProducts.manufactureName,
        'price': productPrice,
        'quantity': selectedQuantity,
        'name': allProducts.productName,
      });
    } catch (e) {
      print("userCartMedicineUpload error: $e");
    }
  }

  Future<List<CartProduct>> fetchUserCartMedicine(String userId) async {
    final List<CartProduct> userFavoriteProduct = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('userCart')
          .get();

      querySnapshot.docs.forEach((doc) {
        String productId = doc.id;
        String productName = doc['name'];
        String productDescription = doc['description'];
        String productPrice = doc['price'];
        String productQuantity = doc['quantity'];
        String productCategory = doc['category'];
        String productCountryOfOrigin = doc['countryOfOrigin'];
        String productManufactureName = doc['manufactureName'];
        String productTypes = doc['medicineTypes'];

        CartProduct cartProduct = CartProduct(
            productId: productId,
            productName: productName,
            productDescription: productDescription,
            productPrice: productPrice,
            productImageUrl: "assets/images/Dolo650.png",
            productAvlQuantity: productQuantity,
            productTypes: productTypes,
            productCategory: productCategory,
            productCountryOfOrigin: productCountryOfOrigin,
            productManufactureName: productManufactureName);

        userFavoriteProduct.add(cartProduct);
      });

      return userFavoriteProduct;
    } catch (e) {
      print("Fetch User Cart Products Error: $e");
      return userFavoriteProduct;
    }
  }

  Future<void> deleteUserCartMedicine(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('userCart')
          .doc(productId)
          .delete();
    } catch (e) {
      print("Delete User Cart Medicine Error: $e");
      throw Exception('Error deleting cart product: $e');
    }
  }

  Future<void> clearUserCart(String userId) async {
    try {
      // Get a reference to the user's cart collection
      CollectionReference cartCollection =
          _firestore.collection('users').doc(userId).collection('userCart');

      // Fetch all documents in the cart collection
      QuerySnapshot querySnapshot = await cartCollection.get();

      // Delete each document in the collection asynchronously
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await cartCollection.doc(doc.id).delete();
      }

      print("User cart cleared successfully.");
    } catch (e) {
      print("Clear User Cart Error: $e");
      throw Exception('Error clearing user cart: $e');
    }
  }

  Future<void> updateOrderHistory(
    String userId,
    List<CartProduct> listCartProducts,
    String orderId,
  ) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('userPreviousOrder')
          .doc(orderId)
          .set({});

      DateTime now = DateTime.now();
      String formattedDate =
          "${now.day.toString().padLeft(2, '0')}:${now.month.toString().padLeft(2, '0')}:${now.year} - ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      for (CartProduct cartProduct in listCartProducts) {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('userPreviousOrder')
            .doc(orderId)
            .collection('products')
            .doc(cartProduct.productName)
            .set({
          'medicineTypes': cartProduct.productTypes,
          'category': cartProduct.productCategory,
          'countryOfOrigin': cartProduct.productCountryOfOrigin,
          'description': cartProduct.productDescription,
          'imageUrl': cartProduct.productImageUrl,
          'manufactureName': cartProduct.productManufactureName,
          'price': cartProduct.productPrice,
          'quantity': cartProduct.productAvlQuantity,
          'name': cartProduct.productName,
          'orderDateandTime': formattedDate,
        });
      }
      print("order-Id updated");
    } catch (e) {
      print("userCartMedicineUpload error: $e");
    }
  }

  Future<List<String>> fetchUserOrderHistoryList(String userId) async {
    final List<String> userOrderHistory = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('userPreviousOrder')
          .get();

      print(
          "Order history query snapshot: ${querySnapshot.docs.length} documents found");

      for (var doc in querySnapshot.docs) {
        print("Document ID: ${doc.id}");
        userOrderHistory.add(doc.id);
      }

      return userOrderHistory;
    } catch (e) {
      print("Fetch User Order History Error: $e");
      return userOrderHistory;
    }
  }

  Future<List<CartProduct>> fetchUserOrderHistoryDetails(
    String userId,
    String orderId,
  ) async {
    final List<CartProduct> userOrderHistoryDetails = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('userPreviousOrder')
          .doc(orderId)
          .collection('products')
          .get();

      querySnapshot.docs.forEach((doc) {
        String productId = doc.id;
        String productName = doc['name'];
        String productDescription = doc['description'];
        String productPrice = doc['price'];
        String productQuantity = doc['quantity'];
        String productCategory = doc['category'];
        String productCountryOfOrigin = doc['countryOfOrigin'];
        String productManufactureName = doc['manufactureName'];
        String productTypes = doc['medicineTypes'];

        CartProduct cartProduct = CartProduct(
            productId: productId,
            productName: productName,
            productDescription: productDescription,
            productPrice: productPrice,
            productImageUrl: "assets/images/Dolo650.png",
            productAvlQuantity: productQuantity,
            productTypes: productTypes,
            productCategory: productCategory,
            productCountryOfOrigin: productCountryOfOrigin,
            productManufactureName: productManufactureName);

        userOrderHistoryDetails.add(cartProduct);
      });

      return userOrderHistoryDetails;
    } catch (e) {
      print("Fetch User Cart Products Error: $e");
      return userOrderHistoryDetails;
    }
  }

  Future<void> deleteUserOrderHistoryTile(String userId, String orderId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('userPreviousOrder')
          .doc(orderId)
          .delete();
    } catch (e) {
      print("Delete User Cart Medicine Error: $e");
      throw Exception('Error deleting cart product: $e');
    }
  }
}
