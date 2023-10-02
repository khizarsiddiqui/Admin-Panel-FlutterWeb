import 'package:admin_dashboard/pages/clients/clients.dart';
import 'package:admin_dashboard/pages/overview/overview.dart';
import 'package:admin_dashboard/pages/products/products.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import '../pages/authentication/authentication.dart';
import '../pages/autoshow/autoshow.dart';
import '../pages/services/services.dart';
import '../pages/orders/orders.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overViewPageRoute:
      return getPageRoute(const OverviewPage());
    case productsPageRoute:
      return getPageRoute(const ProductsPage());
    case clientsPageRoute:
      return getPageRoute(const ClientsPage());
    case ordersPageRoute:
      return getPageRoute(const OrdersPage());
    case autoshowPageRoute:
      return getPageRoute(AutoshowPage());
    case servicesPageRoute:
      return getPageRoute(ServicesPage());
    case authenticationPageRoute:
      return getPageRoute(const AuthenticationPage());
    default:
      return getPageRoute(const OverviewPage());
  }
}

PageRoute getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
