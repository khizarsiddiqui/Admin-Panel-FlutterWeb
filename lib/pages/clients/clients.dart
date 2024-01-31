import 'package:admin_panel/pages/clients/widgets/clients_table.dart';
import 'package:flutter/material.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [
                ClientsTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
