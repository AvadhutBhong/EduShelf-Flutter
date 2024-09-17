import 'dart:io';

import 'package:edu_shelf/services/database.dart';
import 'package:edu_shelf/widgets/support_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool isAdded = false;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  uploadImage() async {
    if (_formKey.currentState!.validate() &&
        selectedImage != null &&
        value != null) {
      setState(() {
        isAdded = true; // Start the animation
      });
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child("blogImage").child(addId);

      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();

      Map<String, dynamic> addProductMap = {
        "Name": nameController.text,
        "description": descriptionController.text,
        "Image": downloadUrl,
        "price": priceController.text,
        "category": value,
      };

      await DatabaseMethods()
          .addProduct(addProductMap, value!)
          .then((value) => {
        selectedImage = null,
        nameController.text = "",
        descriptionController.text = "",
        priceController.text = "",
        this.value = null,
        IconSnackBar.show(context,
            label: 'Product added successfully ',
            snackBarType: SnackBarType.success),
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isAdded = false; // Reset the button state
        });
      });
    } else {
      // Show error message if the image or category is not selected
      IconSnackBar.show(context,
          label: 'Please fill in all fields',
          snackBarType: SnackBarType.fail);
    }
  }

  String? value;
  final List<String> categoryItems = ['TextBook', 'Calculator', 'Graphics Tools'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          "Add",
          style: AppWidget.semiboldTextFieldStyle().copyWith(fontSize: 20),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload the Product Image",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                SizedBox(height: 20.0),
                selectedImage == null
                    ? GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                )
                    : Center(
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Product name",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter product name";
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Product description",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter product description";
                      }
                      return null;
                    },
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Product Category",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: categoryItems
                          .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: AppWidget.semiboldTextFieldStyle()
                                .copyWith(fontWeight: FontWeight.w600),
                          )))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          this.value = value;
                        });
                      },
                      dropdownColor: Colors.white,
                      hint: Text("Select Category"),
                      iconSize: 25,
                      value: value,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Product price (in INR)",
                  style: AppWidget.lightTextFieldStyle(),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter product price";
                      }
                      return null;
                    },
                    controller: priceController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 50),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Only start the upload if all fields are valid
                      if (_formKey.currentState!.validate() &&
                          selectedImage != null &&
                          value != null) {
                        uploadImage();
                      } else {
                        IconSnackBar.show(context,
                            label: 'Please fill in all fields',
                            snackBarType: SnackBarType.fail);
                      }
                    },
                    child: Container(
                      width: 200, // Fixed width
                      height: 50, // Fixed height
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isAdded ? Colors.green : Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(
                        children: [
                          // Animated Green Background
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            left: isAdded ? 0 : -200, // Slide from left to right
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          // Button Content
                          Center(
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: isAdded
                                  ? Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                                  : Text(
                                'Add Product',
                                style: AppWidget.semiboldTextFieldStyle()
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
