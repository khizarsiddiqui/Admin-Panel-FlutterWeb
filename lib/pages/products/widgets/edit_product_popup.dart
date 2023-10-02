import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductPopup extends StatefulWidget {
  final int index;

  EditProductPopup({required this.index});

  @override
  _EditProductPopupState createState() => _EditProductPopupState();
}

class _EditProductPopupState extends State<EditProductPopup> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Product Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name
            TextField(
              decoration: InputDecoration(labelText: 'Product Name'),
            ),

            // Price
            TextField(
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),

            // Rating
            TextField(
              decoration: InputDecoration(labelText: 'Rating'),
              keyboardType: TextInputType.number,
            ),

            // Brand
            TextField(
              decoration: InputDecoration(labelText: 'Brand'),
            ),

            // Category
            TextField(
              decoration: InputDecoration(labelText: 'Category'),
            ),

            // Stock
            TextField(
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),

            // Image Picker
            GestureDetector(
              onTap: () {
                getImage(); // Open the image picker
              },
              child: Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 10),
                    Text('Select an Image'),
                  ],
                ),
              ),
            ),
            _image != null
                ? Image.file(
              _image!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
                : Container(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Implement logic to update the product details and show a success message
            // Example:
            // updateProduct(widget.index);
            Navigator.of(context).pop(); // Close the popup
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Product updated successfully'),
              ),
            );
          },
          child: Text('Update'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the popup
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
//
// class EditProductPopup extends StatefulWidget {
//   final int index;
//
//   EditProductPopup({required this.index});
//
//   @override
//   _EditProductPopupState createState() => _EditProductPopupState();
// }
//
// class _EditProductPopupState extends State<EditProductPopup> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Edit Product Details'),
//       content: const SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Add text fields or other input widgets for editing product details
//             // Example:
//             TextField(
//               decoration: InputDecoration(labelText: 'New Product Name'),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'New Price'),
//             ),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             // Implement logic to update the product details and show a success message
//             // Example:
//             // updateProduct(widget.index);
//             Navigator.of(context).pop(); // Close the popup
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Product updated successfully'),
//               ),
//             );
//           },
//           child: const Text('Update'),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop(); // Close the popup
//           },
//           child: const Text('Cancel'),
//         ),
//       ],
//     );
//   }
// }
