import 'package:flutter/material.dart';

import '../../colors.dart';
import '../product_details.dart';

class HomeProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final String? productId;
  final bool isFromHome;

  const HomeProductCard({Key? key, required this.product, this.productId, this.isFromHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Product image taking maximum space
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
            child: Image.network(
              product['image'],
              height: 170,
              width: double.infinity,
              fit: BoxFit.fitHeight,
            ),
          ),
          // Name and price text on the bottom left
          Positioned(
            left: 8,
            bottom: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Adjusted font size for better fitting
                    color: AppColors.darkGray,
                    backgroundColor: Colors.white70,
                  ),
                  maxLines: 2, // Allow up to 2 lines
                  overflow: TextOverflow.ellipsis, // Continue to truncate with ellipsis if too long
                ),
                SizedBox(height: 4),
                Text(
                  '₹${product['price']}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                    backgroundColor: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Plus sign button aligned to the bottom right
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                // Implement add to cart action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetails(
                      productId: product['productID'],
                      product: product,
                      category: product['category'],
                      isFromHome: isFromHome,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
