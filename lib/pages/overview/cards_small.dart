import 'package:admin_panel/constants/constants.dart';
import 'package:admin_panel/pages/clients/widgets/clients_table.dart';
import 'package:admin_panel/pages/overview/info_card_small.dart';
import 'package:admin_panel/pages/products/products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewCardsSmallScreen extends StatefulWidget {
  const OverviewCardsSmallScreen({super.key});

  @override
  State<OverviewCardsSmallScreen> createState() =>
      _OverviewCardsSmallScreenState();
}

class _OverviewCardsSmallScreenState extends State<OverviewCardsSmallScreen> {
  final CustomersController customersController = Get.find();
  final ProductsController productsController = Get.find();

  @override
  void initState() {
    super.initState();
    productsController.fetchProducts();
    customersController.fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 400,
      child: Obx(
        () => Column(
          children: [
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.productsCount,
              value: productsController.products.length,
              onTap: () {},
            ),
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.customerCount,
              value: customersController.users.length,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
