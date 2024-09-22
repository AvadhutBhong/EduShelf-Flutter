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

  Future addProduct(Map<String, dynamic> userInfoMap, String categoryname) async {
    return await FirebaseFirestore.instance
        .collection(categoryname)
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return await FirebaseFirestore.instance.collection(category).snapshots();
  }
}

