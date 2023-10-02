import 'package:admin_dashboard/pages/orders/widgets/orders_table.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage();

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

// import 'package:admin_dashboard/pages/orders/widgets/orders_table.dart';
// import 'package:flutter/material.dart';
//
// class OrdersPage extends StatelessWidget {
//   const OrdersPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: ListView(
//             children: const [
//               OrdersTable(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
