// ignore_for_file: use_build_context_synchronously
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/style.dart';
import '../../../widgets/custom_text.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProductsTableState createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsPage> {
  final productsController = Get.put(ProductsController());
  final productsCollection = FirebaseFirestore.instance.collection('products');

  final TextEditingController idController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  File? image;
  late FirebaseStorage storage;
  @override
  void initState() {
    super.initState();
    productsController.fetchProducts();
    storage = FirebaseStorage.instance;
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _showUpdatePopup(Products product) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Product'),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                  controller: titleController..text = product.title,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: priceController..text = product.price.toString(),
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: ratingController..text = product.rating.toString(),
                  decoration: const InputDecoration(labelText: 'Rating'),
                ),
                TextField(
                  controller: descriptionController..text = product.description,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                DropdownButtonFormField<String>(
                  onChanged: (String? newValue) {
                    setState(() {
                      categoryController.text = newValue!;
                    });
                  },
                  value: categoryController.text.isNotEmpty ? categoryController.text : null,
                  items: <String>['Spare Part', 'Car Service']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  final updatedData = {
                    'title': titleController.text,
                    'price': double.tryParse(priceController.text) ?? 0.0,
                    'rating': double.tryParse(ratingController.text) ?? 0.0,
                    'description': descriptionController.text,
                    'category': categoryController.text,
                  };

                  await _updateProduct(product.id, updatedData);

                  Fluttertoast.showToast(
                    msg: 'Product updated successfully',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.lightBlueAccent,
                    textColor: Colors.white,
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error updating product: $e');
                }
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

  Future<void> _showAddPopup() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'Id'),
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: ratingController,
                  decoration: const InputDecoration(labelText: 'Rating'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                DropdownButtonFormField<String>(
                  onChanged: (String? newValue) {
                    setState(() {
                      categoryController.text = newValue!;
                    });
                  },
                  items: <String>['Spare Part', 'Car Service']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                Column(
                  children: [
                    if (image != null) // Check if an image is selected
                      Image.file(
                        image!,
                        height: 100,
                      ),
                    ElevatedButton(
                      onPressed: () async {
                        final imagePicker = ImagePicker();
                        final pickedImage = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (pickedImage != null) {
                          setState(() {
                            image = File(pickedImage.path);
                          });
                        }
                      },
                      child: const Text('Pick Image'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (image == null) {
                  Fluttertoast.showToast(
                    msg: "Please select an image",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }
                try {
                  final productData = {
                    'id': idController.text,
                    'title': titleController.text,
                    'price': double.tryParse(priceController.text) ?? 0.0,
                    'rating': double.tryParse(ratingController.text) ?? 0.0,
                    'description': descriptionController.text,
                    'category': categoryController.text,
                  };
                  await _addProduct(productData);
                  Fluttertoast.showToast(
                    msg: "Product added successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.lightBlueAccent,
                    textColor: Colors.white,
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  // ignore: avoid_print
                  print("Error uploading image: $e");
                }
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

  Future<void> _addProduct(Map<String, dynamic> productData) async {
    try {
      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child('product_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Log the product added event
      productsController.logProductAddedEvent(idController.text);
      if (kIsWeb) {
        // For Flutter web, get the image file using html package
        final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
        input.click();

        final completer = Completer<List<int>>();
        input.onChange.listen((e) {
          if (input.files!.isNotEmpty) {
            final reader = html.FileReader();
            reader.readAsArrayBuffer(input.files![0]);
            reader.onLoadEnd.listen(
                  (e) {
                completer.complete(Uint8List.fromList(reader.result as List<int>));
              },
            );
          }
        });

        final buffer = await completer.future;
        await ref.putData(Uint8List.fromList(buffer));
      } else {
        // For mobile, use the regular image picker
        await ref.putFile(image!);
      }

      final imageUrl = await ref.getDownloadURL();
      await productsCollection.add({
        'id': idController.text,
        'title': titleController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'rating': double.tryParse(ratingController.text) ?? 0.0,
        'description': descriptionController.text,
        'category': categoryController.text,
        'image': imageUrl,
      });

      // Fetch products again after adding a new one
      await productsController.fetchProducts();

      idController.clear();
      titleController.clear();
      priceController.clear();
      ratingController.clear();
      descriptionController.clear();
      categoryController.clear();
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    var columns = const [
      // DataColumn(label: Text('Id')),
      DataColumn(label: Text('Product Title')),
      DataColumn(label: Text('Price')),
      DataColumn(label: Text('Rating')),
      DataColumn(label: Text('Product Description')),
      DataColumn(label: Text('Image')),
      DataColumn(label: Text('Category')),
      DataColumn(label: Text('Actions')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: active.withOpacity(.4), width: .5),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                color: lightGray.withOpacity(.1),
                blurRadius: 12,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 30),
          child:
             // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
              AdaptiveScrollbar(
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
                        child: productsController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : DataTable(
                                columns: columns,
                                rows: List<DataRow>.generate(
                                  productsController.products.length,
                                  (index) {
                                    final product =
                                        productsController.products[index];
                                    return DataRow(
                                      cells: [
                                        // DataCell(CustomText(
                                        //   text: product.id.toString(),
                                        // )),
                                        DataCell(CustomText(
                                          text: product.title,
                                        )),
                                        DataCell(CustomText(
                                          text: "Rs.${product.price}",
                                        )),
                                        DataCell(CustomText(
                                          text: product.rating.toString(),
                                        )),
                                        DataCell(CustomText(
                                          text: product.description,
                                        )),
                                        DataCell(
                                          Image.network(product.image),
                                        ),
                                        DataCell(CustomText(
                                          text: product.category,
                                        )),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                color: Colors.redAccent,
                                                onPressed: () => _deleteProduct(product),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                color: Colors.blue,
                                                onPressed: () => _showUpdatePopup(product),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
          //   ],
          // ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddPopup();
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
  Future<String> getDocumentId(String productId) async {
    final productReference = await FirebaseFirestore.instance
        .collection('products')
        .where('id', isEqualTo: productId)
        .get();

    if (productReference.docs.isEmpty) {
      throw Exception('Product with ID $productId not found');
    }
    return productReference.docs.first.id;
  }
  Future<void> _updateProduct(String productId, Map<String, dynamic> updatedData) async {
    try {
      // Get the actual document ID using the getDocumentId function
      final documentId = await getDocumentId(productId);

      // Update the document with the new data
      await FirebaseFirestore.instance.collection('products').doc(documentId).update(updatedData);

      // Log the product updated event
      productsController.logProductUpdatedEvent(productId);

      print('Product updated successfully');
    } catch (e) {
      print('Error updating product: $e');
      Fluttertoast.showToast(
        msg: "Failed to update product. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _deleteProduct(Products product) async {
    try {
      final documentId = await getDocumentId(product.id);
      // Log the product deleted event
      productsController.logProductDeletedEvent(product.id);

      await FirebaseFirestore.instance
          .collection('products')
          .doc(documentId)
          .delete();

      // Update the local products list
      productsController.products.removeWhere((element) => element.id == product.id);

      Fluttertoast.showToast(
        msg: "Product deleted successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.lightBlueAccent,
        textColor: Colors.white,
      );
    } catch (e) {
      print("Error deleting product from Firestore: $e");
      Fluttertoast.showToast(
        msg: "Failed to delete product. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}

class Products {
  String id;
  String title;
  double price;
  double rating;
  String description;
  String image;
  String category;

  Products({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.description,
    required this.image,
    required this.category,
  });

  factory Products.fromMap(String id, Map<String, dynamic> map) {
    return Products(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      price: map['price'] ?? '',
      rating: map['rating'] ?? '',
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      category: map['category'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price ': price,
      'rating': rating,
      'description': description,
      'image': image,
      'category': category,
    };
  }
}

class ProductsController extends GetxController {
  var products = <Products>[].obs;
  var isLoading = true.obs;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  List<Products> get carServiceProducts =>
      products.where((product) => product.category == 'Car Service').toList();
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);

      final CollectionReference productsCollection =
          FirebaseFirestore.instance.collection('products');
      // final QuerySnapshot querySnapshot = await productsCollection.get();
      productsCollection.snapshots().listen((event) {
        final fetchedProducts = event.docs
            .map((doc) =>
                Products.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
        products.assignAll(fetchedProducts);
      });
    } catch (e) {
      // Handle error if needed
      // ignore: avoid_print
      print("Error fetching products: $e");
    } finally {
      isLoading(false);
    }
  }
  // Log product-related events
  void logProductAddedEvent(String productId) {
    analytics.logEvent(
      name: 'product_added',
      parameters: <String, dynamic>{
        'product_id': productId,
      },
    );
  }

  void logProductUpdatedEvent(String productId) {
    analytics.logEvent(
      name: 'product_updated',
      parameters: <String, dynamic>{
        'product_id': productId,
      },
    );
  }

  void logProductDeletedEvent(String productId) {
    analytics.logEvent(
      name: 'product_deleted',
      parameters: <String, dynamic>{
        'product_id': productId,
      },
    );
  }
}
