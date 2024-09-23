import 'dart:io';
import 'package:edu_shelf/services/database.dart';
import 'package:edu_shelf/services/shared_pref.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  final Map<String , dynamic>? product;
  final bool isEditMode;
  AddProduct({super.key, this.product, this.isEditMode = false});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  // Variables
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isAdded = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController sellerContactController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? categoryValue;
  String? conditionValue;

  @override
  void initState() {

    super.initState();
    if (widget.isEditMode && widget.product != null) {
      nameController.text = widget.product!['name'];
      descriptionController.text = widget.product!['description'] ?? 'No description provided';
      priceController.text = widget.product!['price'].toString();
      quantityController.text = widget.product!['quantity'].toString() ?? '0';
      sellerContactController.text = widget.product!['sellerContact'] ?? '0';
      categoryValue = widget.product!['category'];
      conditionValue = widget.product!['condition'] ?? '';

      // Set the image URL for display
      String imageUrl = widget.product!['image'] ?? '';
      if (imageUrl.isNotEmpty) {
        selectedImage = null; // Resetting selectedImage because it's a URL
        // Optionally handle image display if needed
      }
    }
  }

  final List<String> categoryItems = ['TextBook', 'Calculator', 'Graphics Tools'];
  final List<String> conditionItems = ['New', 'Used'];

  // Image Picker Function
  Future<void> getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(image!.path);
    });
  }

  // Upload Image to Firebase Storage
  Future<String> uploadImageToStorage(String addId) async {
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child("productImages").child(addId);
    final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
    return await (await task).ref.getDownloadURL();
  }

  // Handle Phone Update
  Future<void> handlePhoneUpdate(String enteredPhone, String userid) async {
    String? savedPhone = await SharedPreferenceHelper().getUserPhone(userid);
    print('Received savednumber: $savedPhone');

    if (savedPhone == null || savedPhone.isEmpty || savedPhone != enteredPhone) {
      print('Phone number is new or changed, adding/updating.');

      // Update Firestore with the new phone number
      await DatabaseMethods().addUserDetails({
        "phone": enteredPhone,
      }, userid);

      // Save the new phone number to shared preferences
      await SharedPreferenceHelper().saveUserPhone(userid, enteredPhone);
    } else {
      print("Phone number already exists and is the same.");
    }
  }

  // Add Product to Firestore
  Future<void> addProductToFirestore(Map<String, dynamic> productData, String category, String userId) async {
    await DatabaseMethods().addProduct(productData, category, userId).then((value) {
      resetForm();
      showSuccessSnackbar();
    });
  }

  // Upload Product
  Future<void> uploadProduct() async {
    if (_formKey.currentState!.validate() &&
        selectedImage != null &&
        categoryValue != null &&
        conditionValue != null) {
      setState(() {
        isAdded = true; // Start the animation
      });
      print('got 11');
      String addId = widget.isEditMode ? widget.product!['productID'] : randomAlphaNumeric(10);
      String downloadUrl;
      print('gottttt00');
      if (widget.isEditMode && selectedImage == null) {
        downloadUrl = widget.product!['image'];
      } else {
        downloadUrl = await uploadImageToStorage(addId);
      }
      print('got 22');
      String? userid = await SharedPreferenceHelper().getUserId();
      await handlePhoneUpdate(sellerContactController.text.toString(), userid!);
      print('got33');
      Map<String, dynamic> addProductMap = {
        "name": nameController.text,
        "description": descriptionController.text,
        "image": downloadUrl,
        "price": priceController.text,
        "category": categoryValue,
        "condition": conditionValue,
        "quantity": quantityController.text,
        "sellerContact": sellerContactController.text,
        "ownerid": userid,
      };

      try {
        if (widget.isEditMode) {
          await DatabaseMethods().updateProduct(addId, categoryValue!, userid!, addProductMap);
          showSuccessSnackbar(); // Show snackbar on update success
        } else {
          await addProductToFirestore(addProductMap, categoryValue!, userid!);
        }
      } catch (e) {
        print("Error updating product: $e");
        IconSnackBar.show(context,
            label: 'Failed to update product', snackBarType: SnackBarType.fail);
      } finally {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isAdded = false; // Reset the button state
          });
        });
      }
    } else {
      IconSnackBar.show(context,
          label: 'Please fill in all fields', snackBarType: SnackBarType.fail);
    }
  }



  // Reset Form after product is added
  void resetForm() {
    selectedImage = null;
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    quantityController.clear();
    sellerContactController.clear();

    setState(() {
      categoryValue = null;
      conditionValue = null;
    });
  }

  // Show Success Snackbar
  void showSuccessSnackbar() {
    IconSnackBar.show(context,
        label: 'Product added successfully', snackBarType: SnackBarType.success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text("Add Product", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker with Modern UI
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: selectedImage == null
                      ? Center(
                      child: Icon(Icons.camera_alt,
                          size: 50, color: Colors.grey[700]))
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(selectedImage!, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Product Name
              buildTextField("Product Name", nameController,
                  "Enter product name"),

              // Product Description
              buildTextField("Description", descriptionController,
                  "Enter product description",
                  maxLines: 4),

              // Price Field
              buildTextField("Price (INR)", priceController,
                  "Enter price",
                  keyboardType: TextInputType.number),

              // Quantity Field
              buildTextField("Quantity", quantityController,
                  "Enter quantity",
                  keyboardType: TextInputType.number),

              // Category Dropdown
              buildDropdown("Category", categoryItems, categoryValue,
                      (String? newValue) {
                    setState(() {
                      categoryValue = newValue;
                    });
                  }),

              // Condition Dropdown (New/Used)
              buildDropdown("Condition", conditionItems, conditionValue,
                      (String? newValue) {
                    setState(() {
                      conditionValue = newValue;
                    });
                  }),

              // Seller Contact
              buildTextField("Seller Contact", sellerContactController,
                  "Enter your contact number",
                  keyboardType: TextInputType.phone),

              SizedBox(height: 40),

              // Submit Button
              Center(
                child: GestureDetector(
                  onTap: uploadProduct,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 50,
                    width: isAdded ? 150 : 200,
                    decoration: BoxDecoration(
                      color: isAdded ? Colors.green : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isAdded
                          ? Icon(Icons.check, color: Colors.white)
                          : Text(
                        widget.isEditMode ? 'Update Product' : 'Add Product',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Reusable method for input fields
  Widget buildTextField(String label, TextEditingController controller,
      String hint,
      {TextInputType? keyboardType, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Color(0xFFECECEC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // Reusable method for dropdown fields
  // Reusable method for dropdown fields
  Widget buildDropdown(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Color(0xFFECECEC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(selectedValue) ? selectedValue : null, // Ensure it matches one of the items
              isExpanded: true,
              hint: Text("Select $label"),
              items: items.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: TextStyle(fontSize: 16)),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

}
