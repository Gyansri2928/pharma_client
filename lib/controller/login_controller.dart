import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:pharma_client/models/user/user.dart';
import 'package:pharma_client/pages/home_page.dart';

class LoginController extends GetxController {
  GetStorage box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference usercollection;

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  TextEditingController LoginNumber = TextEditingController();

  OtpFieldControllerV2 otp = OtpFieldControllerV2();
  bool otpFieldShow = false;
  int? otpsend;
  int? otpenter;

  User? loginUser;

  @override
  void onReady() {
    Map<String, dynamic>? user=box.read('loginUser');
    if(user!=null){
      loginUser=User.fromJson(user);
      Get.to(const HomePage());
    }
    super.onReady();
  }


  @override
  void onInit() {
    usercollection = firestore.collection('users');
    super.onInit();
  }

  addUser() {
    try {
      if (otpsend == otpenter) {
        DocumentReference doc = usercollection.doc();
        User user =
            User(id: doc.id, name: name.text, number: int.parse(number.text));

        final userJson = user.toJson();
        doc.set(userJson);
        Get.snackbar('Success', 'User added successfully',
            colorText: Colors.green);
        name.clear();
        number.clear();
        otp.clear();
        Get.to(HomePage());
      } else {
        Get.snackbar("Error", "OTP is incorrect", colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.green);
      print(e);
    }
  }

  sendOtp() async {
    try {
      if (name.text.isEmpty || number.text.isEmpty) {
        Get.snackbar('Error', 'Please fill the fields', colorText: Colors.red);
        return;
      }
      final random = Random();
      int otp = 1000 + random.nextInt(9000);
      String mobilenumber = number.text;
      String url =
          'https://www.fast2sms.com/dev/bulkV2?authorization=ClbSem8jT7VhgzasIL9KZAvFYXO5R1Wc6EDxup4qtHJ20if3PwJwliLDPCEz8c1Gy4xt6bT7oMSBVIrh&route=otp&variables_values=$otp&flash=0&numbers=$mobilenumber';
      Response response = await GetConnect().get(url);
      print(otp);

      if (response.body['message'][0] == 'SMS sent successfully.') {
        otpFieldShow = true;
        otpsend = otp;
        Get.snackbar("Success", 'OTP sent successfully',
            colorText: Colors.green);
      } else {
        Get.snackbar("Error", 'Otp Not sent', colorText: Colors.red);
      }
    } catch (e) {
      print(e);
    } finally {
      update();
    }
  }

  Future<void> loginWithPhone() async {
    try {
      String phoneNumber = LoginNumber.text;
      if (phoneNumber.isNotEmpty) {
        var querySnapshot = await usercollection
            .where('number', isEqualTo: int.tryParse(phoneNumber))
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          var userData = userDoc.data() as Map<String, dynamic>;
          box.write('loginUser', userData);
          LoginNumber.clear();
          Get.to(const HomePage());
          Get.snackbar("Success", "Login Successful", colorText: Colors.green);
        } else {
          Get.snackbar("Error", "User not found, please register",
              colorText: Colors.red);
        }
      }else{
        Get.snackbar("Error", "Please enter a phone number",colorText: Colors.red);
      }
    } catch (error) {
        print('Failed to login: $error');
        Get.snackbar("Error", "Failed to login",colorText: Colors.red);

    }
  }
}
