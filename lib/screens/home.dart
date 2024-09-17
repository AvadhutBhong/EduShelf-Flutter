import 'package:edu_shelf/screens/category_products.dart';
import 'package:edu_shelf/services/shared_pref.dart';
import 'package:edu_shelf/widgets/greeting_widget.dart';
import 'package:flutter/material.dart';
import 'package:edu_shelf/colors.dart';
import 'package:edu_shelf/widgets/support_widget.dart';
import 'package:edu_shelf/widgets/home_product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categories = [
    "images/book.png",
    "images/calculator.png",
    "images/drafting_tools.png",
  ];
  List categoryNames = [
    "TextBook",
    "Calculator",
    "Graphics Tools",
  ];

  String? name,image;

  getTheSharedPref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {

    });
  }

  ontheload() async {
    await getTheSharedPref();
    setState(() {

    });
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: name==null ? Center(child: CircularProgressIndicator()) : Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hey, '+name!,
                      style: AppWidget.boldTextFieldStyle(), // Use AppWidget for text style
                    ),
                    GreetingWidget(),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    image!,
                    height: 50,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.lightGray),
                color: AppColors.lightestGray,
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Products",
                  prefixIcon: Icon(Icons.search, color: AppColors.darkGray),
                  hintStyle: AppWidget.lightTextFieldStyle().copyWith(
                    color: AppColors.darkGray,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Categories', style: AppWidget.semiboldTextFieldStyle(),),
                Text('see all', style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 18, fontWeight: FontWeight.bold),),

              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFF08000),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text('All' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold, fontSize: 20),)),
                ),
                Expanded(
                  child: Container(
                    height: 150,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                  return CategoryTile(image: categories[index], name: categoryNames[index],);
                    }),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Products', style: AppWidget.semiboldTextFieldStyle(),),
                Text('see all', style: TextStyle(color: Color(0xFFfd6f3e), fontSize: 18, fontWeight: FontWeight.bold),),

              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 240,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    HomeProductCard(img: "images/book.png",  product_name: "Bluebook",price: 50,),
                    HomeProductCard(img: "images/book.png",  product_name: "Bluebook",price: 50,),
                  ],
                ),
            ),


          ],
        ),
      ),
    );
  }
}


class CategoryTile extends StatelessWidget {
  
    String image,name;
    CategoryTile({required this.image, required this.name});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryProducts(category: name)));
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(left: 20.0),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Image.asset(image, height: 70,width: 60,fit: BoxFit.cover,),
            Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
