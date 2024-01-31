import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_panel/pages/products/products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/style.dart';
import '../../../widgets/custom_text.dart';

class TopSellingProducts extends StatefulWidget {
  const TopSellingProducts({Key? key}) : super(key: key);

  @override
  State<TopSellingProducts> createState() => _TopSellingProductsState();
}

class _TopSellingProductsState extends State<TopSellingProducts> {
  final ProductsController productsController = Get.find();

  @override
  void initState() {
    super.initState();
    productsController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var columns = const [
      DataColumn(label: Text('Id')),
      DataColumn(label: Text('Title')),
      DataColumn(label: Text('Price')),
      DataColumn(label: Text('Rating')),
      DataColumn(label: Text('Description')),
      DataColumn(label: Text('Category')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: active.withOpacity(.4), width: .5),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                color: lightGray.withOpacity(.1),
                blurRadius: 12,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  CustomText(
                    text: "Top Selling Products",
                    color: lightGray,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              AdaptiveScrollbar(
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: active.withOpacity(0.7),
                sliderActiveColor: active,
                controller: verticalScrollController,
                child: AdaptiveScrollbar(
                  controller: horizontalScrollController,
                  position: ScrollbarPosition.bottom,
                  underColor: lightGray.withOpacity(0.3),
                  sliderDefaultColor: active.withOpacity(0.7),
                  sliderActiveColor: active,
                  width: 13.0,
                  sliderHeight: 100.0,
                  child: SingleChildScrollView(
                    controller: verticalScrollController,
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      controller: horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: productsController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : DataTable(
                                columns: columns,
                                rows: List<DataRow>.generate(
                                  productsController.products.length,
                                  (index) => DataRow(
                                    cells: [
                                      DataCell(CustomText(
                                        text: productsController
                                            .products[index].id
                                            .toString(),
                                      )),
                                      DataCell(CustomText(
                                        text: productsController
                                            .products[index].title,
                                      )),
                                      DataCell(CustomText(
                                        text:
                                            "Rs.${productsController.products[index].price}",
                                      )),
                                      DataCell(CustomText(
                                        text: productsController
                                            .products[index].rating
                                            .toString(),
                                      )),
                                      DataCell(CustomText(
                                        text: productsController
                                            .products[index].description,
                                      )),
                                      DataCell(CustomText(
                                        text: productsController
                                            .products[index].category,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
