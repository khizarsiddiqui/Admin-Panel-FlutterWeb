import 'product.dart'; // Import your existing Product model

class Orders {
  List<Orders>? orders;
  int? total;
  int? skip;
  int? limit;

  Orders({this.orders, this.total, this.skip, this.limit});

  Orders.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}
class Order {
  final int id;
  final List<Product> products; // Use your existing Product class
  final double total;
  final double discountedTotal;
  final int userId;
  final int totalProducts;
  final int totalQuantity;

  Order({
    required this.id,
    required this.products,
    required this.total,
    required this.discountedTotal,
    required this.userId,
    required this.totalProducts,
    required this.totalQuantity,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final List<dynamic> productsJson = json['products'];

    final List<Product> products = productsJson.map((productJson) {
      return Product.fromJson(productJson);
    }).toList();

    return Order(
      id: json['id'],
      products: products,
      total: json['total'].toDouble(),
      discountedTotal: json['discountedTotal'].toDouble(),
      userId: json['userId'],
      totalProducts: json['totalProducts'],
      totalQuantity: json['totalQuantity'],
    );
  }
}

// class Order {
//   int id;
//   List<Product> products;
//   int total;
//   double discountedTotal;
//   int userId;
//   int totalProducts;
//   int totalQuantity;
//
//   Order({
//     required this.id,
//     required this.products,
//     required this.total,
//     required this.discountedTotal,
//     required this.userId,
//     required this.totalProducts,
//     required this.totalQuantity,
//   });
//
//   factory Order.fromJson(Map<String, dynamic> json) {
//     var productsList = json['products'] as List;
//     List<Product> products =
//     productsList.map((i) => Product.fromJson(i)).toList();
//
//     return Order(
//       id: json['id'],
//       products: products,
//       total: json['total'],
//       discountedTotal: json['discountedTotal'].toDouble(),
//       userId: json['userId'],
//       totalProducts: json['totalProducts'],
//       totalQuantity: json['totalQuantity'],
//     );
//   }
// }
//
// class Product {
//   int id;
//   String title;
//   double price;
//   int quantity;
//   double total;
//   double discountPercentage;
//   double discountedPrice;
//
//   Product({
//     required this.id,
//     required this.title,
//     required this.price,
//     required this.quantity,
//     required this.total,
//     required this.discountPercentage,
//     required this.discountedPrice,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       title: json['title'],
//       price: json['price'].toDouble(),
//       quantity: json['quantity'],
//       total: json['total'].toDouble(),
//       discountPercentage: json['discountPercentage'].toDouble(),
//       discountedPrice: json['discountedPrice'].toDouble(),
//     );
//   }
// }
//
// class ApiResponse {
//   List<Order> orders;
//   int total;
//   int skip;
//   int limit;
//
//   ApiResponse({
//     required this.orders,
//     required this.total,
//     required this.skip,
//     required this.limit,
//   });
//
//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     var ordersList = json['orders'] as List;
//     List<Order> orders = ordersList.map((i) => Order.fromJson(i)).toList();
//
//     return ApiResponse(
//       orders: orders,
//       total: json['total'],
//       skip: json['skip'],
//       limit: json['limit'],
//     );
//   }
// }
