//import 'package:admin_dashboard/constants/controllers.dart';
//import 'package:admin_dashboard/helpers/responsiveness.dart';
// import 'package:admin_dashboard/pages/clients/widgets/clients_table.dart';
import 'package:admin_dashboard/pages/orders/widgets/orders_table.dart';
//import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: const [
              OrdersTable(),
            ],
          ),
        ),
      ],
    );
  }
}
