import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  List<CarPackage> packages = []; // List to store car packages
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('carPackages')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        packages = snapshot.docs.map((doc) {
          // ignore: unnecessary_cast
          final data = doc.data() as Map<String, dynamic>;
          return CarPackage(
            id: doc.id,
            name: data['name'],
            description: data['description'],
            price: data['price'].toDouble(),
          );
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Packages'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Packages: ${packages.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showAddPackageDialog(context),
              child: const Text('Add Package'),
            ),
            const SizedBox(height: 16),
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
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(package.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${package.description}'),
            Text('Price: Rs${package.price.toStringAsFixed(2)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditPackageDialog(context, package),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
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
          title: const Text('Add Car Package'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, 'Package Name'),
              _buildTextField(descriptionController, 'Package Description'),
              _buildTextField(priceController, 'Package Price (Rs)'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addPackage();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
          title: const Text('Edit Car Package'),
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
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
      final newPackage = CarPackage(
          id: '', name: name, description: description, price: price);
      // Add the new package to Firestore
      FirebaseFirestore.instance.collection('carPackages').add({
        'name': newPackage.name,
        'description': newPackage.description,
        'price': newPackage.price,
      });
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
      // Update the package in Firestore
      FirebaseFirestore.instance
          .collection('carPackages')
          .doc(package.id)
          .update({
        'name': name,
        'description': description,
        'price': price,
      });

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
    // Delete the package from Firestore
    FirebaseFirestore.instance
        .collection('carPackages')
        .doc(package.id)
        .delete();

    setState(() {
      packages.remove(package);
    });
  }
}

class CarPackage {
  String id; // Add the 'id' property
  String name;
  String description;
  double price;

  CarPackage({
    required this.id, // Initialize 'id' in the constructor
    required this.name,
    required this.description,
    required this.price,
  });
}
