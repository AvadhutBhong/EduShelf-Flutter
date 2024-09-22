import 'package:flutter/material.dart';

class PreSellPage extends StatelessWidget {
  const PreSellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),

              // Title
              Text(
                "Start Selling!",
                style: TextStyle(
                  color: Color(0xFF002244),
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Description
              Text(
                "Join a vibrant community of college students. Upload your study materials, textbooks, or other products, and start making sales instantly.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),

              // Image or Animation Placeholder
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Book Image in the background
                      Image.asset(
                        "images/book_sell.png",
                        fit: BoxFit.contain,
                        width: 180, // Adjusted to fit within the container
                      ),
                      // Rupees Symbol on top of the book image
                      Positioned(
                        top: 10, // Adjusted position for better layout
                        left: 10,
                        child: Image.asset(
                          "images/rupee.png",
                          width: 50, // Adjusted to the appropriate size
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Sell Benefits
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBenefitRow(Icons.check, "No listing fees, it's free!"),
                  SizedBox(height: 15),
                  _buildBenefitRow(Icons.check, "Reach a large student audience"),
                  SizedBox(height: 15),
                  _buildBenefitRow(Icons.check, "Easy-to-use platform"),
                ],
              ),
              SizedBox(height: 60),

              // "Proceed to Sell" Button
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/addproduct");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF003366),
                        Color(0xFF002244),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Proceed to Sell",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFF002244),
          size: 20,
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
