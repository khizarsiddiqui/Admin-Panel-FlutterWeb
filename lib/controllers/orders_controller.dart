import 'package:admin_dashboard/service/orders_service.dart';
import 'package:get/get.dart';
import '../models/order.dart';

class OrdersController extends GetxController {
  var orders = <Order>[].obs;
  var isLoading = true.obs;

  void fetchOrders() async {
    try {
      isLoading.value = true; // Use .value to update the observable
      final orders = await OrdersService().fetchOrders();
      if (orders.isNotEmpty) {
        this.orders.assignAll(orders);
      }
    } finally {
      isLoading.value = false; // Use .value to update the observable
    }
  }
}

// import 'package:admin_dashboard/service/orders_service.dart';
// import 'package:get/get.dart';
// import '../models/order.dart';
//
// class OrdersController extends GetxController {
//   var orders = <Order>[].obs;
//   var isLoading = true.obs;
//
//   void fetchOrders() async {
//     try {
//       isLoading(true);
//       final orders = await OrdersService().fetchOrders();
//       if (orders.isNotEmpty) {
//         this.orders.assignAll(orders);
//       }
//     } finally {
//       isLoading(false);
//     }
//   }
// }