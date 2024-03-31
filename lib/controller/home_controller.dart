import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product/product.dart';
import '../models/product_category/product_category.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  List<Product> products = [];
  List<Product> productfromUI = [];
  List<ProductCategory> productCategory = [];

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('Category');
    await fetchproducts();
    await fetchcategory();
    super.onInit();
  }

  fetchproducts() async {
    try {
      QuerySnapshot productsnapshot = await productCollection.get();
      final List<Product> retrieveproduct = productsnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.clear();
      products.assignAll(retrieveproduct);
      productfromUI.assignAll(products);
      Get.snackbar('Success', "Product fetched successfully",
          colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.green);
    } finally {
      update();
    }
  }

  fetchcategory() async {
    try {
      QuerySnapshot categorysnapshot = await categoryCollection.get();
      final List<ProductCategory> retrieveCategory = categorysnapshot.docs
          .map((doc) =>
              ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      productCategory.clear();
      productCategory.assignAll(retrieveCategory);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.green);
    } finally {
      update();
    }
  }

  filterByCategory(String category) {
    productfromUI.clear();
    productfromUI =
        products.where((product) => product.category == category).toList();
    update();
  }
  filterByBrand(List<String> brands){
    if(brands.isEmpty){
      productfromUI=products;
    }
    else{
      List<String> lowerCaseBrands = brands.map((brand) => brand.toLowerCase()).toList();
      productfromUI=products.where((product) => lowerCaseBrands.contains(product.brand?.toLowerCase())).toList();
    }
    update();
  }
  sortByPrice({required bool ascending}){
    List<Product> sortedProducts = List<Product>.from(productfromUI);
    sortedProducts.sort((a,b)=> ascending ? a.price!.compareTo(b.price!):b.price!.compareTo(a.price!));
    productfromUI=sortedProducts;
    update();
  }
}
