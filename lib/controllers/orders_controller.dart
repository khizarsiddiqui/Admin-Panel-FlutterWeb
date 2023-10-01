import 'package:admin_dashboard/service/customers_service.dart';
import 'package:get/get.dart';
import '../models/order.dart';

class OrdersController extends GetxController {
  var orders = <Order>[].obs;
  var isLoading = true.obs;

  void fetchOrders() async {
    try {
      isLoading(true);
      final customers = await CustomerService().fetchCustomers();
      if (customers.isNotEmpty) {
        this.orders.assignAll(orders);
      }
    } finally {
      isLoading(false);
    }
  }

}