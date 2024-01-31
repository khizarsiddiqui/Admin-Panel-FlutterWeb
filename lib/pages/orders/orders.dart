// ignore_for_file: non_constant_identifier_names
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/style.dart';
import '../../../widgets/custom_text.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<OrdersPage> {
  final OrdersController ordersController = Get.put(OrdersController());

  @override
  void initState() {
    super.initState();
    ordersController.fetchOrders();
  }

  DataRow _buildOrderRow(Order order) {
    return DataRow(
      cells: [
        DataCell(_buildCell(order.id, order.isDelivered)),
        DataCell(_buildCell(order.productNames.toString(), order.isDelivered)),
        DataCell(_buildCell(order.total.toString(), order.isDelivered)),
        DataCell(_buildCell(order.fullName, order.isDelivered)),
        DataCell(_buildCell(order.address, order.isDelivered)),
        DataCell(_buildCell(order.phoneNumber, order.isDelivered)),
        DataCell(_buildCell(order.totalProducts.toString(), order.isDelivered)),
        DataCell(_buildCell(order.totalQuantity.toString(), order.isDelivered)),
        DataCell(
          _buildActionButton(
            order.isDelivered ? 'Order Delivered' : 'Mark as Delivered',
                () {
              if (order.isDelivered) {
                ordersController.markAsUndelivered(order);
              } else {
                ordersController.markAsDelivered(order);
              }
            },
            order.isDelivered,
          ),
        ),
      ],
    );
  }

  Widget _buildCell(String text, bool isDelivered) {
    return Container(
      decoration: BoxDecoration(
        color: isDelivered ? Colors.grey : Colors.white,
        border: Border.all(color: Colors.transparent),
      ),
      child: CustomText(text: text),
    );
  }

  Widget _buildActionButton(String label, void Function() onPressed, bool isDelivered) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isDelivered ? Colors.lightBlueAccent : light,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active, width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: CustomText(
          text: label,
          color: active.withOpacity(0.7),
          weight: FontWeight.bold,
        ),
      ),
    );
  }


@override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text('Order ID')),
      DataColumn(label: Text('Product Name')),
      DataColumn(label: Text('Total')),
      DataColumn(label: Text('User Name')),
      DataColumn(label: Text('Address')),
      DataColumn(label: Text('Phone Number')),
      DataColumn(label: Text('Total Products')),
      DataColumn(label: Text('Total Quantity')),
      DataColumn(label: Text('Actions')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: active.withOpacity(.4), width: .5),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 6),
                  color: Colors.lightBlueAccent.withOpacity(.1),
                  blurRadius: 12),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 30),
          child: AdaptiveScrollbar(
            underColor: Colors.blueGrey.withOpacity(0.3),
            sliderDefaultColor: Colors.lightBlueAccent.withOpacity(0.7), // Change to light blue
            sliderActiveColor: Colors.lightBlueAccent, // Change to light blue
            controller: verticalScrollController,
            child: AdaptiveScrollbar(
              controller: horizontalScrollController,
              position: ScrollbarPosition.bottom,
              underColor: lightGray.withOpacity(0.3),
              sliderDefaultColor: Colors.lightBlueAccent.withOpacity(0.7), // Change to light blue
              sliderActiveColor: Colors.lightBlueAccent, // Change to light blue
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
                    child: ordersController.isLoading.value
                        ? const CircularProgressIndicator()
                        : DataTable(
                            columns: columns,
                            rows: ordersController.orders
                                .map((order) => _buildOrderRow(order))
                                .toList(),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class OrdersController extends GetxController {
  var orders = <Order>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  final OrdersService _ordersService = OrdersService();

  void markAsDelivered(Order order) async {
    try {
      isLoading.value = true;
      // Mark the order as delivered
      order.isDelivered = true;
      await _ordersService.updateOrder(order.id, order);
      // Fetch orders to refresh the list
      fetchOrders();
    } finally {
      isLoading.value = false;
    }
  }

  void markAsUndelivered(Order order) async {
    try {
      isLoading.value = true;
      // Mark the order as not delivered (undo delivery)
      order.isDelivered = false;
      await _ordersService.updateOrder(order.id, order);
      // Fetch orders to refresh the list
      fetchOrders();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final fetchedOrders = await _ordersService.fetchOrders();
      // ignore: avoid_print
      print("Fetched orders: $fetchedOrders"); // Add this line
      if (fetchedOrders.isNotEmpty) {
        orders.assignAll(fetchedOrders);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void addOrder(Order order) async {
    try {
      isLoading.value = true;
      await _ordersService.addOrder(order);
      fetchOrders();
    } finally {
      isLoading.value = false;
    }
  }

  void updateOrder(String orderId, Order order) async {
    try {
      isLoading.value = true;
      await _ordersService.updateOrder(orderId, order);
      fetchOrders();
    } finally {
      isLoading.value = false;
    }
  }

  void deleteOrder(String orderId) async {
    try {
      isLoading.value = true;
      await _ordersService.deleteOrder(orderId);
      fetchOrders();
    } finally {
      isLoading.value = false;
    }
  }
}

class OrdersService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Order>> fetchOrders() async {
    try {
      final ordersCollection = firestore.collection('orders');
      final querySnapshot = await ordersCollection.get();

      final orders = querySnapshot.docs.map((doc) {
        return Order.fromSnapshot(doc);
      }).toList();
      // ignore: avoid_print
      print("Fetched ${orders.length} orders.");

      return orders;
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching orders: $e");
      return <Order>[];
    }
  }

  Future<void> addOrder(Order order) async {
    final ordersCollection = firestore.collection('orders');
    await ordersCollection.add(order.toMap());
  }

  Future<void> updateOrder(String orderId, Order order) async {
    final ordersCollection = firestore.collection('orders');
    await ordersCollection.doc(orderId).update(order.toMap());
  }

  Future<void> deleteOrder(String orderId) async {
    final ordersCollection = firestore.collection('orders');
    await ordersCollection.doc(orderId).delete();
  }
}

class Order {
  final String id;
  final List<String> productNames;
  final double total;
  final String fullName;
  final int totalProducts;
  final int totalQuantity;
  final String address;
  final String phoneNumber;
  bool isDelivered; // New property to track the delivery status

  Order({
    required this.id,
    required this.productNames,
    required this.total,
    required this.fullName,
    required this.totalProducts,
    required this.totalQuantity,
    required this.address,
    required this.phoneNumber,
    this.isDelivered = false, // Initialize as not delivered
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'fullName': fullName,
      'totalProducts': totalProducts,
      'totalQuantity': totalQuantity,
      'productNames': productNames,
      'address': address,
      'phoneNumber': phoneNumber,
      'isDelivered': isDelivered, // Include the delivery status
    };
  }

  factory Order.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Order(
      id: data['id'] as String? ?? '',
      productNames: (data['productNames'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      address: data['address'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      fullName: data['fullName'] as String? ?? '',
      totalProducts: data['totalProducts'] as int? ?? 0,
      totalQuantity: data['totalQuantity'] as int? ?? 0,
      isDelivered: data['isDelivered'] as bool? ?? false, // Load delivery status
    );
  }
}
