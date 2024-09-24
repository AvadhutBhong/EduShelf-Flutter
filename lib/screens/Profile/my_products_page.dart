import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_shelf/services/database.dart';
import 'package:flutter/material.dart';

import '../../admin/add_product.dart';
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
    getUserId();
  }

  Future<void> getUserId() async {
    userId = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  Stream<QuerySnapshot> getUserProductsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myProducts')
        .snapshots();
  }

  Future<void> deleteProduct(String productId, String category) async {
    await DatabaseMethods().deleteProduct(productId, category, userId!);
  }

  Future<void> updateProduct(Map<String, dynamic> productData) async {
    Map<String, dynamic> sanitizedProductData = {
      'name': productData['name'] ?? 'Untitled Product',
      'price': productData['price']?.toString() ?? '0',  // Convert price to string if it's a number
      'image': productData['image'],          // Default to empty string if imageURL is null
      'category': productData['category'] ?? 'Uncategorized',
      'ownerid': productData['ownerid'] ?? '',
      'productID' : productData['productID'],
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProduct(
          product: sanitizedProductData,  // Pass the sanitized product data
          isEditMode: true,
        ),
      ),
    );
  }


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

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var product = snapshot.data!.docs[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product['image'] ?? 'default_image_url', // Fallback for image
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'] ?? 'Unknown Product',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Price: ₹${product['price']?.toString() ?? '0'}", // Handle null price
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Category: ${product['category'] ?? 'Uncategorized'}", // Default category
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Column(
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
                      ],
                    ),
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
