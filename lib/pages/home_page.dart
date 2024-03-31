import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharma_client/controller/home_controller.dart';
import 'package:pharma_client/pages/login_page.dart';
import 'package:pharma_client/pages/product_detail.dart';
import 'package:pharma_client/widget/multi_select_dropdown.dart';
import 'package:pharma_client/widget/product_cart.dart';

import '../models/product_category/product_category.dart';
import '../widget/drop_down.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      // Reorder categories to display selected first
      List<ProductCategory> orderedCategories = List.from(ctrl.productCategory)
        ..sort((a, b) => a.isSelected ? -1 : 1);

      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchproducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "FootWare Store",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    GetStorage box = GetStorage();
                    box.erase();
                    Get.offAll(LoginPage());
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orderedCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          ctrl.filterByCategory(
                              orderedCategories[index].name ?? " ");
                          orderedCategories[index].isSelected =
                              !orderedCategories[index].isSelected;
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Chip(
                            label: Text(
                              orderedCategories[index].name ?? 'No name',
                              style: TextStyle(
                                color: orderedCategories[index].isSelected
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            backgroundColor: orderedCategories[index].isSelected
                                ? Colors.blue
                                : Colors.grey[300],
                          ),
                        ),
                      );
                    }),
              ),
              Row(
                children: [
                  Flexible(
                    child: DropDown(
                      items: ['Rs. Low to High', 'Rs. High to Low'],
                      hnttxt: "Sort items",
                      onSelected: (selected) {
                        ctrl.sortByPrice(
                            ascending:
                                selected == 'Rs: Low to High' ? true : false);
                      },
                    ),
                  ),
                  Flexible(
                      child: MultiSelDropDown(
                    items: ['Adidas', 'Reebok', 'Bata', 'Puma'],
                    onSelectionChanged: (selectedItems) {
                      ctrl.filterByBrand(selectedItems);
                    },
                  ))
                ],
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.8),
                    itemCount: ctrl.productfromUI.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: ctrl.productfromUI[index].name ?? 'No name',
                        imageUrl: ctrl.productfromUI[index].image ?? 'url',
                        price: ctrl.productfromUI[index].price ?? 00,
                        OfferTag: '20% OFF',
                        onTap: () {
                          Get.to(Product_Description_Page(
                            ImageUrl: ctrl.products[index].image ?? 'url',
                            name: ctrl.products[index].name ?? 'No name',
                            price: ctrl.products[index].price ?? 00,
                          ));
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}
