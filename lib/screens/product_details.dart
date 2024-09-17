import 'package:edu_shelf/colors.dart';
import 'package:edu_shelf/widgets/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xfffef5f1),
      body: Container(
        padding: EdgeInsets.only(top: 50,),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),border: Border.all(), ),
                      child: Icon(Icons.arrow_back_rounded)),
                ),
                Center(child: Image.asset("images/book.png", height: 400,)),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top:20, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Headphone', style: AppWidget.boldTextFieldStyle(),),
                        Text('\$300', style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 22, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text('Details' , style: AppWidget.semiboldTextFieldStyle(),),
                    SizedBox(height: 10,),
                    Text('Nirali Engineering Mathematics 2 TextBook Sem-II '),
                    SizedBox(height: 90,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFfd6f3e),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text('Buy Now', style: TextStyle(color: AppColors.offWhite, fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
}
