import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_shelf/services/shared_pref.dart';

class EditProfilePage extends StatefulWidget {
  final String? username;
  final String? useremail;
  final String? userImage;
  final String? userphone;
  final String? userid;

  const EditProfilePage({
    super.key,
    required this.username,
    required this.useremail,
    required this.userImage,
    required this.userphone,
    required this.userid,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _image;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.username ?? '';
    _emailController.text = widget.useremail ?? '';
    _phoneController.text = widget.userphone ?? '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      isUpdating = true;
    });

    String updatedName = _nameController.text.trim();
    String updatedEmail = _emailController.text.trim();
    String updatedPhone = _phoneController.text.trim();
    String? updatedImageUrl;

    // Handle image upload to Firebase Storage
    if (_image != null) {
      final storageRef = FirebaseStorage.instance.ref().child('user_images/${widget.userid}');
      await storageRef.putFile(_image!);
      updatedImageUrl = await storageRef.getDownloadURL();
    }

    // Update Firestore
    await FirebaseFirestore.instance.collection('users').doc(widget.userid).update({
      'Name': updatedName,
      'Email': updatedEmail,
      'phone': updatedPhone,
      'Image': updatedImageUrl ?? widget.userImage,
    });

    // Update Shared Preferences
    await SharedPreferenceHelper().saveUserName(updatedName);
    await SharedPreferenceHelper().saveUserEmail(updatedEmail);
    await SharedPreferenceHelper().saveUserPhone(widget.userid!, updatedPhone);
    if (updatedImageUrl != null) {
      await SharedPreferenceHelper().saveUserImage(updatedImageUrl);
    }

    setState(() {
      isUpdating = false;
    });

    // Pass updated data back to Profile page
    Navigator.pop(context, {
      'Name': updatedName,
      'Email': updatedEmail,
      'phone': updatedPhone,
      'Image': updatedImageUrl ?? widget.userImage,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back_rounded, color: Colors.white,)),
      ),
      body: isUpdating
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : NetworkImage(widget.userImage!) as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_emailController, 'Email'),
              _buildTextField(_phoneController, 'Phone Number'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Update Profile', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
