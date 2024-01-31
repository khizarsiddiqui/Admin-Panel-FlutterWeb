import 'package:admin_panel/pages/clients/clients.dart';
import 'package:admin_panel/pages/overview/overview.dart';
import 'package:admin_panel/pages/products/products.dart';
import 'package:admin_panel/routing/routes.dart';
import 'package:flutter/material.dart';

import '../pages/appointments/appointments.dart';
import '../pages/authentication/authentication.dart';
import '../pages/autoshow/autoshow.dart';
import '../pages/bookTicket/bookTicket.dart';
import '../pages/orders/orders.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overViewPageRoute:
      return getPageRoute(OverviewPage());
    case productsPageRoute:
      return getPageRoute(const ProductsPage());
    case clientsPageRoute:
      return getPageRoute(const ClientsPage());
    case ordersPageRoute:
      return getPageRoute(const OrdersPage());
    case autoshowPageRoute:
      return getPageRoute(const AutoshowPage());
    // case servicesPageRoute:
    //   return getPageRoute(const ServicesPage());
    case appointmentsPageRoute:
      return getPageRoute(const AppointmentsPage());
    case bookTicketPageRoute:
      return getPageRoute(const BookTicketPage());
    case authenticationPageRoute:
      return getPageRoute(const AuthenticationPage());
    default:
      return getPageRoute(OverviewPage());
  }
}

PageRoute getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
