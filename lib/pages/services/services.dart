import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  List<CarPackage> packages = []; // List to store car packages
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Packages'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Packages: ${packages.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showAddPackageDialog(context),
              child: Text('Add Package'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  return _buildPackageCard(packages[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(CarPackage package) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(package.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${package.description}'),
            Text('Price: \Rs${package.price.toStringAsFixed(2)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _showEditPackageDialog(context, package),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deletePackage(package),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPackageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Car Package'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, 'Package Name'),
              _buildTextField(descriptionController, 'Package Description'),
              _buildTextField(priceController, 'Package Price (\Rs)'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addPackage();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditPackageDialog(BuildContext context, CarPackage package) {
    nameController.text = package.name;
    descriptionController.text = package.description;
    priceController.text = package.price.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Car Package'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, 'Package Name'),
              _buildTextField(descriptionController, 'Package Description'),
              _buildTextField(priceController, 'Package Price (\$)'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updatePackage(package);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  void _addPackage() {
    final name = nameController.text;
    final description = descriptionController.text;
    final price = double.tryParse(priceController.text);

    if (name.isNotEmpty && description.isNotEmpty && price != null) {
      final newPackage = CarPackage(name: name, description: description, price: price);
      setState(() {
        packages.add(newPackage);
      });

      // Clear input fields
      nameController.clear();
      descriptionController.clear();
      priceController.clear();
    }
  }

  void _updatePackage(CarPackage package) {
    final name = nameController.text;
    final description = descriptionController.text;
    final price = double.tryParse(priceController.text);

    if (name.isNotEmpty && description.isNotEmpty && price != null) {
      setState(() {
        package.name = name;
        package.description = description;
        package.price = price;
      });

      // Clear input fields
      nameController.clear();
      descriptionController.clear();
      priceController.clear();
    }
  }

  void _deletePackage(CarPackage package) {
    setState(() {
      packages.remove(package);
    });
  }
}

class CarPackage {
  String name;
  String description;
  double price;

  CarPackage({required this.name, required this.description, required this.price});
}

