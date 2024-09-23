import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_shelf/services/database.dart';
import 'package:flutter/material.dart';

import '../../services/shared_pref.dart';

class MyProductsPage extends StatefulWidget {
  @override
  _MyProductsPageState createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  String? userId;

  @override
  void initState() {
    super.initState();
    // Fetch userId from shared preferences or other storage
    getUserId();
  }

  Future<void> getUserId() async {
    userId = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  // Fetch user's products from Firestore
  Stream<QuerySnapshot> getUserProductsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myProducts')
        .snapshots();
  }

  // Delete product from Firestore
  Future<void> deleteProduct(String productId, String category) async {
    await DatabaseMethods().deleteProduct(productId, category, userId!);
  }

  // Update product (Navigate to AddProductPage with current product details)
  Future<void> updateProduct(Map<String, dynamic> productData) async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AddProductPage(
    //       product: productData, // Pass existing product details to edit
    //       isEditMode: true,
    //     ),
    //   ),
    // );
  }

  // Confirmation Dialog for delete
  Future<void> showDeleteConfirmationDialog(String productId, String category) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await deleteProduct(productId, category);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Products"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserProductsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "You haven't uploaded any products yet.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          // Display the products in a list
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var product = snapshot.data!.docs[index];
              return ListTile(
                leading: Image.network(product['imageURL'], width: 50, height: 50),
                title: Text(product['title']),
                subtitle: Text("Price: ₹${product['price']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        updateProduct(product.data() as Map<String, dynamic>);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDeleteConfirmationDialog(
                            product.id, product['category']);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
