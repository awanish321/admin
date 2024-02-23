import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../models/category_models.dart';

class EditCategoryScreen extends StatefulWidget {
  final CategoryModel category;
  final String image;

  const EditCategoryScreen({super.key, required this.category, required this.image});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  File? selectedImage;
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryController.text = widget.category.category;
  }

  Future<void> _updateCategory() async {
    // FireStore reference to the category document
    DocumentReference categoryRef =
    FirebaseFirestore.instance.collection('Categories').doc(widget.category.id);

    // Prepare the updated data
    Map<String, dynamic> updatedData = {
      'category': categoryController.text,
    };

    // Check if a new image has been selected
    if (selectedImage != null) {
      // Upload the new image to Firebase Storage
      String imageUrl = await uploadImageToStorage(selectedImage!);
      updatedData['image'] = imageUrl; // Update the image URL in FireStore
    }

    try {
      // Update the category document in FireStore
      await categoryRef.update(updatedData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update category'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Function to upload an image to Firebase Storage
  Future<String> uploadImageToStorage(File imageFile) async {
    Reference storageRef = FirebaseStorage.instance.ref().child('Category_images/${widget.category.id}');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w500),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              selectedImage != null
                  ? Image.file(selectedImage!, width: 200, height: 200)
                  : Image.network(
                widget.image, // Display the current image
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file != null) {
                      selectedImage = File(file.path);
                      setState(() {});
                    }
                  },
                  child: Text('Select Image', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white),),
                ),
              ),
              const SizedBox(height: 30,),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                controller: categoryController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Category Name',
                    labelStyle: GoogleFonts.nunitoSans()
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _updateCategory();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}