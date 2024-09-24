import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/database.dart';
import 'home_product_card.dart';

class CategoryProducts extends StatefulWidget {
  final String category;

  const CategoryProducts({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  final int batchSize = 10; // Number of products to load per batch
  late ScrollController _scrollController;
  List<DocumentSnapshot> _products = [];
  bool isLoading = false;
  bool hasMore = true; // To track if more products are available
  DocumentSnapshot? lastDocument; // Track the last document for pagination

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    fetchCategoryProducts(); // Initial load
  }

  // Fetch products for a specific category with pagination
  Future<void> fetchCategoryProducts() async {
    if (isLoading || !hasMore) return; // Prevent duplicate calls
    setState(() {
      isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.category)
        .collection('products')
        .limit(batchSize);

    // If we already have loaded some products, fetch the next batch
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    // If the query has fewer products than batch size, it means no more products
    if (querySnapshot.docs.length < batchSize) {
      hasMore = false;
    }

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;
      setState(() {
        _products.addAll(querySnapshot.docs); // Add new products to the list
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  // Infinite scroll listener
  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
      // Load more products when the user scrolls to the bottom
      fetchCategoryProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2; // 3 columns for larger screens, 2 for small

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black54,
      ),
      body: _products.isEmpty && isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading initially
          : GridView.builder(
        padding: EdgeInsets.all(16),
        controller: _scrollController, // Attach the scroll controller
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, // 2 or 3 columns based on screen size
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 2 / 3, // Adjust to control card height
        ),
        itemCount: _products.length + (hasMore ? 1 : 0), // Add extra item for the loader
        cacheExtent: 500, // Cache extent to cache 500 pixels off-screen
        itemBuilder: (context, index) {
          if (index == _products.length) {
            // Show a loading spinner at the bottom when loading more products
            return Center(child: CircularProgressIndicator());
          }

          var product = _products[index].data() as Map<String, dynamic>;
          return HomeProductCard(product: product ,);
        },
      ),
    );
  }
}
