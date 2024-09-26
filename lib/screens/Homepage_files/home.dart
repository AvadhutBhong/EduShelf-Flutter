import 'package:edu_shelf/screens/Homepage_files/category_products.dart';
import 'package:edu_shelf/services/shared_pref.dart';
import 'package:edu_shelf/utils/search_helper.dart';
import 'package:edu_shelf/widgets/greeting_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../colors.dart';
import '../../services/database.dart';
import 'home_product_card.dart';
import 'search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name, image;
  String searchQuery = ''; // Track the current search query
  final DatabaseMethods databaseMethods = DatabaseMethods();
  late Stream<QuerySnapshot<Map<String, dynamic>>> productStream; // Updated to QuerySnapshot
  TextEditingController searchController = TextEditingController(); // Add a controller for the search bar

  @override
  void initState() {
    super.initState();
    getTheSharedPref();
    productStream = getAllProductsStream(); // Default product stream
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  getTheSharedPref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  void onSearchQueryChanged(String query) {
    setState(() {
      searchQuery = query;
      productStream = query.isEmpty
          ? getAllProductsStream() // All products stream
          : searchProductsStream(query); // Search-specific stream
    });
  }

  void clearSearch() {
    FocusScope.of(context).unfocus(); // Close the keyboard
    setState(() {
      searchQuery = '';
      productStream = getAllProductsStream(); // Reset to all products
      searchController.clear(); // Clear the text in the search bar
    });
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
              HomeSearchBar(
                onSearch: onSearchQueryChanged,
                searchQuery: searchQuery, // Pass current search query
                onClear: clearSearch, // Use the clearSearch method
              ),
              const SizedBox(height: 20.0),
              if (searchQuery.isEmpty) ...[
                CategorySection(),
                const SizedBox(height: 20),
              ],
              AllProductsSection(productStream: productStream, searchQuery: searchQuery),
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
              style: TextStyle(
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
        Text(
          'Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
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
                      builder: (context) =>
                          CategoryProducts(category: categoryNames[index]),
                    ),
                  );
                },
                child: CategoryCard(
                  image: categories[index],
                  title: categoryNames[index],
                ),
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
  final Stream<QuerySnapshot<Map<String, dynamic>>> productStream; // Keep this as is
  final String searchQuery;

  const AllProductsSection({Key? key, required this.productStream, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          searchQuery.isEmpty ? 'Featured Products' : 'Search Results',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

            final products = snapshot.data!.docs;

            // If there's a search query, filter the products here
            List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredProducts;
            if (searchQuery.isNotEmpty) {
              filteredProducts = products.where((product) {
                final data = product.data();
                final nameMatches = data['name'].toString().toLowerCase().contains(searchQuery.toLowerCase());
                final descriptionMatches = data['description'].toString().toLowerCase().contains(searchQuery.toLowerCase());
                final categoryMatches = data['category'].toString().toLowerCase().contains(searchQuery.toLowerCase());
                return nameMatches || descriptionMatches || categoryMatches;
              }).toList();
            } else {
              filteredProducts = products; // No filtering
            }

            // Render the filtered list of products
            if (searchQuery.isEmpty) {
              return Container(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: products.map((product) {
                    return HomeProductCard(
                      product: product.data(),
                    );
                  }).toList(),
                ),
              );
            } else {
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  var product = filteredProducts[index];
                  return HomeProductCard(
                    product: product.data(),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}




