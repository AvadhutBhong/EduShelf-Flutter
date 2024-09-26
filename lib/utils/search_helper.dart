import 'package:cloud_firestore/cloud_firestore.dart';

// Fetches all products from the Firestore collection
Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsStream() {
  return FirebaseFirestore.instance
      .collection('globalProducts')
      .orderBy('timestamp', descending: true)
      .snapshots();
}

// Fetches products based on the search query
Stream<QuerySnapshot<Map<String, dynamic>>> searchProductsStream(String query) {
  // Convert query to lowercase for case-insensitive search
  final lowerCaseQuery = query.toLowerCase();

  return FirebaseFirestore.instance
      .collection('globalProducts')
      .snapshots() // Get all products stream
      .asyncMap((snapshot) async {
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> results = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final nameMatches = data['name'].toString().toLowerCase().contains(lowerCaseQuery);
      final descriptionMatches = data['description'].toString().toLowerCase().contains(lowerCaseQuery);
      final categoryMatches = data['category'].toString().toLowerCase().contains(lowerCaseQuery);

      if (nameMatches || descriptionMatches || categoryMatches) {
        results.add(doc); // Add only matching documents
      }
    }

    // Create a new snapshot only if you need to return filtered data; however, we won't be returning a QuerySnapshot.
    // Just return the original filtered results in your StreamBuilder.
    return snapshot; // Return the original snapshot to be used in the UI logic.
  });
}
