import 'package:flutter/material.dart';
import 'package:edu_shelf/widgets/support_widget.dart';
class HomeProductCard extends StatelessWidget {
  const HomeProductCard({
    super.key,
    required this.img,
    required this.product_name,
    required this.price,

  });
  final String img;
  final String product_name;
  final int price;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Image.asset(img, height: 150, width: 150,fit: BoxFit.cover,),
          Text(product_name, style: AppWidget.semiboldTextFieldStyle(),),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("\$${price}", style: TextStyle(color: Color(0xFFfd6f3e) , fontSize: 22.0, fontWeight: FontWeight.bold),),
              SizedBox(width: 40,),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color(0xfffd6f3e),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add , color: Colors.white70,),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
