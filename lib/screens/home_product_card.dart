// product_card.dart
import 'package:flutter/material.dart';
import '../colors.dart';

class HomeProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const HomeProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              product['image'], // Adjust according to your image field name
              height: 170, // Adjust height for better visibility
              width: double.infinity,
              fit: BoxFit.cover, // Ensure the image fills the space
            ),
          ),
          // Name and price text on the bottom left
          Positioned(
            left: 8,
            bottom: 10, // Position for product name
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'], // Adjust according to your product name field name
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.darkGray,
                    backgroundColor: Colors.white70, // Optional background for better visibility
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '₹${product['price']}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                    backgroundColor: Colors.white70, // Optional background for better visibility
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
