const rootRoute = "/home";

const overViewPageDisplayName = "Overview";
const overViewPageRoute = "/overview";

const productsPageDisplayName = "Products";
const productsPageRoute = "/products";

const clientsPageDisplayName = "Customers";
const clientsPageRoute = "/customers";

const ordersPageDisplayName = "Orders";
const ordersPageRoute = "/orders";

const autoshowPageDisplayName = "Autoshow";
const autoshowPageRoute = "/autoshow";

const appointmentsPageDisplayName = "Appointments";
const appointmentsPageRoute = "/appointments";

const bookTicketPageDisplayName = "Book Tickets";
const bookTicketPageRoute = "/bookTickets";

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
  MenuItem(name: appointmentsPageDisplayName, route: appointmentsPageRoute),
  MenuItem(name: bookTicketPageDisplayName, route: bookTicketPageRoute),
  MenuItem(name: authenticationDisplayName, route: authenticationPageRoute),
];
