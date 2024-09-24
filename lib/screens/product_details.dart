import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_shelf/widgets/support_widget.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final String? productId;
  final Map<String, dynamic>? product;
  final String? category;
  final bool isFromHome;

  ProductDetails({super.key, this.productId, this.product, this.category , this.isFromHome = false});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // Fetch product details based on productId
  Future<Map<String, dynamic>?> fetchProductDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.category)
          .collection('products')
          .doc(widget.productId)
          .get();


      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching product details: $e");
      return null;
    }
  }

  // Fetch owner details based on ownerId
  Future<Map<String, dynamic>?> fetchOwnerDetails(String ownerId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(ownerId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching owner details: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine whether to use the product passed or fetch it
    Future<Map<String, dynamic>?> productFuture;

    if (widget.product !=null && widget.isFromHome ==false) {
      // If product details are provided, use them directly
      productFuture = Future.value(widget.product);
      print('Using passed product data: ${widget.product}');
    } else if (widget.isFromHome) {
      // If productId is available, fetch the details from Firestore
      print('i guesss we need to fetch');
      productFuture = fetchProductDetails();
    } else {
      // Handle the case where no product information is available
      return Center(child: Text('Product not found'));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF3F4F6),
        body: FutureBuilder<Map<String, dynamic>?>( // Update to use productFuture
          future: productFuture,
          builder: (context, productSnapshot) {
            if (productSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (productSnapshot.hasError) {
              return Center(child: Text('Error fetching product details'));
            } else if (!productSnapshot.hasData || productSnapshot.data == null) {
              return Center(child: Text('Product not found'));
            } else {
              var product = productSnapshot.data!;
              String ownerId = product['ownerid'] ?? '';

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button and Label
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.arrow_back, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Product Details',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Image and other details
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Container(
                        color: Colors.black12,
                        child: Stack(
                          children: [
                            Container(
                              height: 400,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(product['image'] ?? ''),
                                  fit: BoxFit.contain,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.2),
                                    Colors.black.withOpacity(0.6),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              top: 20,
                              child: GestureDetector(
                                onTap: () {
                                  // Add to Wishlist or Favorite Functionality
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.favorite_border, color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Product Details Section
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product['name'] ?? 'Unnamed Product',
                                  style: TextStyle(
                                    fontSize: 24, // Slightly smaller for better fit
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    overflow: TextOverflow.ellipsis,

                                  ),
                                ),
                              ),
                              SizedBox(width: 10), // Small space between name and price
                              Text(
                                '₹${product['price'] ?? '0'}',
                                style: TextStyle(
                                  color: Color(0xFF002244),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Product Description
                          Text(
                            product['description'] ?? 'No details available.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 10), // Space after description
                          // Other product info
                          _buildInfoText('Category: ${product['category'] ?? 'undefined'}'),
                          _buildInfoText('Quantity: ${product['quantity'] ?? '1'}'),
                          _buildInfoText('Condition: ${product['condition'] ?? 'New'}'),
                          _buildInfoText('Stock Status: ${product['stockStatus'] ?? 'Available'}'),
                          SizedBox(height: 20), // Space before Owner Details
                          // Owner Details
                          Text('Seller Contact Details:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          FutureBuilder<Map<String, dynamic>?>(
                            future: fetchOwnerDetails(ownerId),
                            builder: (context, ownerSnapshot) {
                              if (ownerSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (ownerSnapshot.hasError) {
                                return Text('Error fetching owner details');
                              } else if (!ownerSnapshot.hasData || ownerSnapshot.data == null) {
                                return Text('Owner not found');
                              } else {
                                var ownerData = ownerSnapshot.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoText('Owner: ${ownerData['Name'] ?? 'Unknown Owner'}'),
                                    _buildInfoText('Contact: ${ownerData['phone'] ?? 'No contact info'}'),
                                  ],
                                );
                              }
                            },
                          ),
                          SizedBox(height: 30), // Space before Chat Button
                          // Chat Button
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add your onPressed functionality here
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'CHAT WITH OWNER',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // Consistent vertical spacing
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
