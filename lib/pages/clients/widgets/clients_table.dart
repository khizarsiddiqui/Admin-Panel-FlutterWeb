import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../constants/style.dart';
import '../../../widgets/custom_text.dart';

class ClientsTable extends StatefulWidget {
  const ClientsTable({super.key});

  @override
  State<ClientsTable> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<ClientsTable> {
  final customersController = Get.put(CustomersController());
  final customersCollection = FirebaseFirestore.instance.collection('users');
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // ignore: unused_element
  void _addCustomer() {
    customersCollection.add({
      'username': usernameController.text,
      'name': nameController.text,
      'email': emailController.text,
      'address': addressController.text,
      'phone': phoneController.text,
    });

    // Clear the text fields
    usernameController.clear();
    nameController.clear();
    emailController.clear();
    addressController.clear();
    phoneController.clear();
  }

  // ignore: unused_element
  void _updateCustomer(DocumentSnapshot doc, String newUsername, String newName,
      String newEmail, String newAddress, String newPhone) {
    doc.reference.update({
      'username': newUsername,
      'name': newName,
      'email': newEmail,
      'address': newAddress,
      'phone': newPhone,
    });
  }

  // ignore: unused_element
  void _deleteCustomer(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .delete();

      // Update the local customers list
      customersController.users.removeWhere((element) => element.userId == user.userId);

      Fluttertoast.showToast(
        msg: "Customer deleted successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.lightBlueAccent,
        textColor: Colors.white,
      );
    } catch (e) {
      print("Error deleting customer from Firestore: $e");
      Fluttertoast.showToast(
        msg: "Failed to delete customer. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var columns = const [
      DataColumn(label: Text('Full Name')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Phone')),
      DataColumn(label: Text('Address')),
      DataColumn(label: Text('Actions')),
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
                child: customersController.isLoading.value
                    ? const CircularProgressIndicator()
                    : DataTable(
                  columns: columns,
                  rows: List<DataRow>.generate(
                    customersController.users.length,
                        (index) => DataRow(cells: [
                      DataCell(CustomText(
                        text: customersController
                            .users[index].fullName
                            .toString(),
                      )),
                      DataCell(CustomText(
                          text: customersController.users[index].email
                              .toString())),
                      DataCell(CustomText(
                          text: customersController.users[index].phone
                              .toString())),
                      DataCell(CustomText(
                        text: customersController.users[index].address
                            .toString())),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red,),
                            onPressed: () {
                              _deleteCustomer(customersController.users[index]);
                            },
                          ),),
                     ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class User {
  final String userId;
  final String address;
  final String email;
  final String fullName;
  final String password;
  final String phone;

  User({
    required this.userId,
    required this.address,
    required this.email,
    required this.fullName,
    required this.password,
    required this.phone,
  });

  factory User.fromMap(String userId, Map<dynamic, dynamic> map) {
    return User(
      userId: userId,
      address: map['address'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      password: map['password'] ?? '',
      phone: map['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'email ': email,
      'fullName': fullName,
      'password': password,
      'phone': phone,
    };
  }
}

class CustomersController extends GetxController {
  var users = <User>[].obs;
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      isLoading(true);

      final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('users');
      final QuerySnapshot querySnapshot = await productsCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        final fetchedProducts = querySnapshot.docs
            .map((doc) =>
            User.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();

        users.assignAll(fetchedProducts);
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      isLoading(false);
    }
  }

  void setCustomers(List<User> usersList) {}
}

class CustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> fetchCustomers() async {
    final customersSnapshot = await _firestore.collection('users').get();
    return customersSnapshot.docs;
  }
}