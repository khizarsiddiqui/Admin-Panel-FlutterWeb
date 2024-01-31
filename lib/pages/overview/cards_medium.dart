import 'package:admin_panel/constants/constants.dart';
import 'package:admin_panel/pages/clients/widgets/clients_table.dart';
import 'package:admin_panel/pages/overview/info_card.dart';
import 'package:admin_panel/pages/products/products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewCardsMediumScreen extends StatefulWidget {
  const OverviewCardsMediumScreen({super.key});

  @override
  State<OverviewCardsMediumScreen> createState() =>
      _OverviewCardsMediumScreenState();
}

class _OverviewCardsMediumScreenState extends State<OverviewCardsMediumScreen> {
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
    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
            Row(
              children: [
                InfoCard(
                  title: Constants.productsCount,
                  value: productsController.products.length,
                  topColor: Colors.redAccent,
                  onTap: () {},
                ),
                InfoCard(
                  title: Constants.customerCount,
                  value: customersController.users.length,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
        ],
      ),
    );
  }
}
