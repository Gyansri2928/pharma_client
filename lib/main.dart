//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:pharma_client/controller/login_controller.dart';
import 'package:pharma_client/controller/purchase_controller.dart';
//import 'package:pharma_client/pages/Register_page.dart';
import 'package:pharma_client/pages/login_page.dart';
//import 'package:pharma_client/pages/home_page.dart';

import 'controller/home_controller.dart';
import 'firebase_options.dart';
//import 'package:pharma_client/pages/login_page.dart';

void main()async{
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(PurchaseController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true
      ),
      home: LoginPage(),
    );
  }
}
