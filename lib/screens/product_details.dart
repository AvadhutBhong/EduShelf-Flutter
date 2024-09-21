import 'package:edu_shelf/colors.dart';
import 'package:edu_shelf/widgets/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class ProductDetails extends StatefulWidget {
  ProductDetails({super.key, required this.name , required this.image, required this.detail , required this.price});
  String image , name , detail , price;
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
                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),border: Border.all(), ),
                      child: Icon(Icons.arrow_back)),
                ),
                // SizedBox(height: 40,),
                Center(

                    child: Image.network(widget.image, height: 400,)),
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
                        Text(widget.name, style: AppWidget.boldTextFieldStyle(),),
                        Text('₹'+widget.price, style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 22, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text('Details' , style: AppWidget.semiboldTextFieldStyle(),),
                    SizedBox(height: 10,),
                    Text(widget.detail),
                    SizedBox(height: 90,),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your onPressed functionality here
                      // Navigator.pushNamed(context, "/personalchat");
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                      side: BorderSide(color: Colors.black, width: 2), // Border color and width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded border
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
                    ),
                    child: Text(
                      'CHAT WITH OWNER',
                      style: TextStyle(
                        fontSize: 16, // Text size
                        fontWeight: FontWeight.bold, // Text style
                      ),
                    ),
                  ),),
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
