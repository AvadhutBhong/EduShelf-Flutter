import 'package:edu_shelf/screens/category_products.dart';
import 'package:edu_shelf/services/shared_pref.dart';
import 'package:edu_shelf/widgets/greeting_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../colors.dart';
import '../services/database.dart';
import '../widgets/support_widget.dart';
import 'home_product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name, image;
  final DatabaseMethods databaseMethods = DatabaseMethods();
  late Stream<QuerySnapshot> productStream = Stream.empty(); // Initialize with an empty stream

  Stream<QuerySnapshot> getAllProductsStream() {
    return FirebaseFirestore.instance
        .collection('globalProducts')
        .orderBy('timestamp' , descending: true)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    getTheSharedPref();
    productStream = getAllProductsStream(); // Stream for products
  }

  getTheSharedPref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GreetingSection(name: name, image: image),
              const SizedBox(height: 20.0),
              SearchBar(),
              const SizedBox(height: 20.0),
              CategorySection(),
              const SizedBox(height: 20),
              AllProductsSection(productStream: productStream),
            ],
          ),
        ),
      ),
    );
  }
}


class GreetingSection extends StatelessWidget {
  final String? name;
  final String? image;

  const GreetingSection({Key? key, this.name, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name != null ? 'Hey, $name' : 'Hey, Guest',
              style: AppWidget.boldTextFieldStyle().copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            GreetingWidget(),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: image != null
              ? Image.network(
            image!,
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          )
              : Container(
            height: 50,
            width: 50,
            color: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search Products',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final List<String> categories = [
    "images/book.png",
    "images/calculator.png",
    "images/drafting_tools.png",
  ];
  final List<String> categoryNames = [
    "TextBook",
    "Calculator",
    "Graphics Tools",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories', style: AppWidget.semiboldTextFieldStyle().copyWith(fontSize: 20)),
        SizedBox(height: 20),
        Container(
          height: 150,
          child: ListView.builder(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryProducts(category: categoryNames[index]),
                    ),
                  );
                },
                child: CategoryCard(image: categories[index], title: categoryNames[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String image;
  final String title;

  const CategoryCard({Key? key, required this.image, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
        border: Border.all(width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 70, width: 60, fit: BoxFit.cover),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AllProductsSection extends StatelessWidget {
  final Stream<QuerySnapshot> productStream;

  const AllProductsSection({Key? key, required this.productStream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Featured Products', style: AppWidget.semiboldTextFieldStyle().copyWith(fontSize: 20)), // Changed title to "Featured Products"
        SizedBox(height: 20),
        StreamBuilder<QuerySnapshot>(
          stream: productStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No products available.'));
            }

            // Limit the number of displayed products (e.g., first 5)
            final limitedProducts = snapshot.data!.docs.take(10).toList();

            return Container(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: limitedProducts.map((product) {
                  return HomeProductCard(
                    product: product.data() as Map<String, dynamic>,
                  );
                }).toList(),
              ),
            );
          },
        ),


      ],
    );
  }
}



