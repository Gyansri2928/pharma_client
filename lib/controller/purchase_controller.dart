import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user/user.dart';
import 'login_controller.dart';

class PurchaseController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  TextEditingController addressController = TextEditingController();
  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';

  @override
  void onInit() {
    orderCollection = firestore.collection("orders");
    super.onInit();
  }

  submitOrder(
      {required double price,
      required String item_name,
      required String description}) {
    orderPrice = price;
    itemName = item_name;
    orderAddress = addressController.text;
  }

  void onBuy() {
    Get.snackbar("Success", "Payment is Successfull", colorText: Colors.green);
  }

  Future<void> orderSuccess({required String? OrderId})async{
    User? loginUse=Get.find<LoginController>().loginUser;
    try{
      DocumentReference docRef= await orderCollection.add({
        'customer':loginUse?.name??"",
        'phone':loginUse?.number??"",
        'item':itemName,
        'price':orderPrice,
        'address':orderAddress,
        'transactionId':OrderId,
        'dateTime':DateTime.now().toString()
      });
      print("Order Created Successfully: ${docRef.id}");
      Get.snackbar("Success", "Order Created Successfully",colorText: Colors.green);

    }catch(e){
      print("Failed to register user: $e");
      Get.snackbar("Error", "Failed to create order",colorText: Colors.red);
    }
  }
}
