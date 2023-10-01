import 'package:get/get.dart';
import '../constants/constants.dart';
import '../models/order.dart';

class OrdersService extends GetConnect {
  Future<List<Order>> fetchOrders() async {
    final response = await get(Constants.ordersUrl);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      final List orders = response.body;
      return orders.map((order) => Order.fromJson(order)).toList();
    }
  }
}