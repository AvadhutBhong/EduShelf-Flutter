import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future<void> addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap, SetOptions(merge: true))
        .then((_) {
      print("User details added/updated successfully.");
    })
        .catchError((e) {
      print("Error updating user details: $e");
    });
  }

  Future<void> addProduct(Map<String, dynamic> productData, String categoryName, String userId) async {
    // Start a batch write for atomic operations
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // 1. Add full product details to the CategoryCollection
    DocumentReference categoryDocRef = FirebaseFirestore.instance
        .collection('Categories')
        .doc(categoryName)
        .collection('products')
        .doc(); // Auto-generated document ID
    batch.set(categoryDocRef, productData);

    // Extract necessary fields for global and myProducts collections
    Map<String, dynamic> minimalProductData = {
      'productID': categoryDocRef.id,
      'title': productData['name'],
      'price': productData['price'],
      'imageURL': productData['image'],
      'category': productData['category'],
      'ownerid': productData['ownerid'],
    };

    // 2. Add minimal details to GlobalCollectionAllProducts
    DocumentReference globalDocRef = FirebaseFirestore.instance
        .collection('globalProducts')
        .doc(categoryDocRef.id); // Use the same product ID
    batch.set(globalDocRef, minimalProductData);

    // 3. Add minimal details to MyProductsCollection for the user
    DocumentReference myProductsDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myProducts')
        .doc(categoryDocRef.id); // Use the same product ID
    batch.set(myProductsDocRef, minimalProductData);

    // Commit the batch write
    await batch.commit();
  }

  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return await FirebaseFirestore.instance.collection(category).snapshots();
  }

  Future<void> deleteProduct(String productId, String category, String userId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Remove from Category Collection
    DocumentReference categoryDoc = FirebaseFirestore.instance
        .collection('Categories')
        .doc(category)
        .collection('products')
        .doc(productId);
    batch.delete(categoryDoc);

    // Remove from Global Collection
    DocumentReference globalDoc = FirebaseFirestore.instance
        .collection('globalProducts')
        .doc(productId);
    batch.delete(globalDoc);

    // Remove from MyProducts Collection
    DocumentReference myProductsDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('myProducts')
        .doc(productId);
    batch.delete(myProductsDoc);

    // Commit batch deletion
    await batch.commit();
  }
}

