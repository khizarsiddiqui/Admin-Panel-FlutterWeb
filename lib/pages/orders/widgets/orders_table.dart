import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/style.dart';
import 'package:admin_dashboard/models/order.dart';
import '../../../controllers/orders_controller.dart';
import '../../../widgets/custom_text.dart';

class OrdersTable extends StatefulWidget {
  const OrdersTable({super.key});

  @override
  State<OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<OrdersTable> {
  final OrdersController ordersController = Get.put(OrdersController());


  @override
  void initState() {
    super.initState();
    ordersController.fetchOrders();
  }


  @override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text('Order ID')),
      DataColumn(label: Text('Total')),
      DataColumn(label: Text('Discounted Total')),
      DataColumn(label: Text('User ID')),
      DataColumn(label: Text('Total Products')),
      DataColumn(label: Text('Total Quantity')),
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
              color: Colors.lightBlueAccent.withOpacity(.1),
              blurRadius: 12)
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: AdaptiveScrollbar(
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
                child:
                ordersController.isLoading.value
                    ? const CircularProgressIndicator() :
                DataTable(
                  columns: columns,
                  rows: List<DataRow>.generate(
                    ordersController.orders.length,
                        (index) {
                      final order = ordersController.orders[index];
                      return DataRow(cells: [
                        DataCell(CustomText(text: order.id.toString())),
                        DataCell(CustomText(text: order.total.toString())),
                        DataCell(CustomText(text: order.discountedTotal.toString())),
                        DataCell(CustomText(text: order.userId.toString())),
                        DataCell(CustomText(text: order.totalProducts.toString())),
                        DataCell(CustomText(text: order.totalQuantity.toString())),
                        DataCell(Container(
                          decoration: BoxDecoration(
                            color: light,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: active, width: .5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: CustomText(
                            text: 'Delete',
                            color: active.withOpacity(.7),
                            weight: FontWeight.bold,
                          ),
                        )),
                      ]);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    )
    );
  }
}
