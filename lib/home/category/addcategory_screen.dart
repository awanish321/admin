
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/images.dart';
import '../../models/category_models.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController category_name = TextEditingController();
  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl = '';
  File? selectedImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              selectedImage != null
                  ? Image.file(selectedImage!, width: 200, height: 200)
                  : Image.asset(imagePlaceholder, width: 200, height: 200),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                    if (file == null) return;
                    selectedImage = File(file.path);
                    setState(() {});
                  },
                  child: Text("Select Image", style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white),),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                controller: category_name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "Category Name",
                  labelStyle: GoogleFonts.nunitoSans()
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true; // Show the progress indicator
                    });

                    await Future.delayed(const Duration(seconds: 2));

                    // Upload the image to Firebase Storage
                    if (selectedImage != null) {
                      Reference referenceRoot =
                      FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                      referenceRoot.child('Category_images');
                      Reference referenceImageToUpload =
                      referenceDirImages.child(uniquefilename);
                      try {
                        await referenceImageToUpload.putFile(selectedImage!);
                        imageUrl =
                        await referenceImageToUpload.getDownloadURL();
                        print("Image URL: $imageUrl");
                      } catch (error) {
                        print("Error uploading image: $error");
                      }
                    } else {
                      print("No image selected.");
                    }

                    // Add category to FireStore
                    final newCategory = CategoryModel(
                      category: category_name.text,
                      image: imageUrl,
                      timestamp: Timestamp.now(),
                      id: 'user_id',
                    );

                    FirebaseFirestore.instance
                        .collection("Categories")
                        .add(newCategory.toJson())
                        .then((value) {
                      category_name.clear();
                      selectedImage = null;
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Category Added Successfully")),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                    "Add Category",
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

