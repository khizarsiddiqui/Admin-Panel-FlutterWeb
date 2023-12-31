const rootRoute = "/home";

const overViewPageDisplayName = "Overview";
const overViewPageRoute = "/overview";

const productsPageDisplayName = "Products";
const productsPageRoute = "/products";

const clientsPageDisplayName = "Clients";
const clientsPageRoute = "/clients";

const ordersPageDisplayName = "Orders";
const ordersPageRoute = "/orders";

const autoshowPageDisplayName = "Autoshow";
const autoshowPageRoute = "/autoshow";

const servicesPageDisplayName = "Services";
const servicesPageRoute = "/services";

const authenticationDisplayName = "Log Out";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem({required this.name, required this.route});
}

List<MenuItem> sideMenuItems = [
  MenuItem(name: overViewPageDisplayName, route: overViewPageRoute),
  MenuItem(name: productsPageDisplayName, route: productsPageRoute),
  MenuItem(name: clientsPageDisplayName, route: clientsPageRoute),
  MenuItem(name: ordersPageDisplayName, route: ordersPageRoute),
  MenuItem(name: autoshowPageDisplayName, route: autoshowPageRoute),
  MenuItem(name: servicesPageDisplayName, route: servicesPageRoute),
  MenuItem(name: authenticationDisplayName, route: authenticationPageRoute),
];
