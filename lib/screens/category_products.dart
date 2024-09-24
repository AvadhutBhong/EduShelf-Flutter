import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_shelf/screens/product_details.dart';
import 'package:edu_shelf/services/database.dart';
// import 'package:edu_shelf/widgets/home_product_card.dart';
import 'package:flutter/material.dart';

import '../widgets/support_widget.dart';

class CategoryProducts extends StatefulWidget {
  String category;
  CategoryProducts({super.key, required this.category});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  Stream? categoryStream;

  getontheload() async {
    // categoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {

    });
  }
 @override
  void initState(){
    getontheload();
    super.initState();
  }

  Widget allProducts(){
    return StreamBuilder(stream: categoryStream, builder: (context , AsyncSnapshot snapshot){
      return snapshot.hasData? GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6 , mainAxisSpacing: 10, crossAxisSpacing: 10),itemCount: snapshot.data.docs.length, itemBuilder:(context,index){
        DocumentSnapshot ds= snapshot.data.docs[index];
        return Container(
          // margin: EdgeInsets.only(right: 10,left:10,top: 20),
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
          decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Image.network(ds["Image"], height: 190, width: 150,fit: BoxFit.cover,),
              Text(ds["Name"], style: AppWidget.semiboldTextFieldStyle().copyWith(fontSize: 16),),
              // SizedBox(height: 10,),
              Spacer(),
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("₹"+ds["price"], style: TextStyle(color: Color(0xFFfd6f3e) , fontSize: 22.0, fontWeight: FontWeight.bold),),
                  SizedBox(width: 40,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context)=> ProductDetails(name: ds["Name"], image: ds["Image"], detail: ds["description"], price: ds["price"])));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xfffd6f3e),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.add , color: Colors.white70,),
                    ),
                  ),

                ],
              ),
            ],
          ),
        );
      }):Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: allProducts()),
          ],
        ),
      ),
    );
  }
}
