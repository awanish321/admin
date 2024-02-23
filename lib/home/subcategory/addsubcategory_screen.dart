import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/images.dart';
import '../../models/subcategory_model.dart';
class AddSubCategoryScreen extends StatefulWidget {
  const AddSubCategoryScreen({super.key});

  @override
  State<AddSubCategoryScreen> createState() => _AddSubCategoryScreenState();
}

class _AddSubCategoryScreenState extends State<AddSubCategoryScreen> {
  TextEditingController subcategoryNameController = TextEditingController();
  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl = '';
  File? selectedImage;
  bool isLoading = false;
  String? selectedCategory; // Variable to hold the selected category
  List<String> dropdownItems = []; // List to store dropdown items

  @override
  void initState() {
    super.initState();
    fetchDropdownItems(); // Fetch dropdown items when the screen loads
  }

  // Function to fetch dropdown items from Firestore
  Future<void> fetchDropdownItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection("Categories").get();

      List<String> categories = querySnapshot.docs
          .map((doc) => (doc.data())['category'] as String)
          .toList();

      setState(() {
        dropdownItems = categories;
      });
    } catch (error) {
      print("Error fetching dropdown items: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add SubCategory', style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontWeight: FontWeight.bold)),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Image picker
            selectedImage != null
                ? Image.file(selectedImage!, width: 200, height: 200)
                : Image.asset(imagePlaceholder, width: 200, height: 200),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () async {
                  final imagePicker = ImagePicker();
                  final XFile? file = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (file == null) return;
                  selectedImage = File(file.path);
                  setState(() {});
                },
                child: Text("Select Image", style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),),
              ),
            ),
            const SizedBox(height: 20),
            // Dropdown menu for categories
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: dropdownItems
                  .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              ))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedCategory = value; // Capture the selected category
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                ),
                labelText: "Category",
                labelStyle: GoogleFonts.nunitoSans()
              ),
            ),
            const SizedBox(height: 20),
            // Subcategory name field
            TextFormField(
              style: GoogleFonts.nunitoSans(),
              controller: subcategoryNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: "Subcategory Name",
                labelStyle: GoogleFonts.nunitoSans()
              ),
            ),
            const SizedBox(height: 20),
            // Button to add subcategory
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () async {
                  setState(() {
                    isLoading = true; // Show loading indicator
                  });

                  // Add a delay for at least 2 seconds
                  await Future.delayed(const Duration(seconds: 2));

                  // Upload the image to Firebase Storage
                  if (selectedImage != null) {
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                    referenceRoot.child('Subcategory_images');
                    Reference referenceImageToUpload =
                    referenceDirImages.child(uniquefilename);
                    try {
                      await referenceImageToUpload.putFile(selectedImage!);
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                      print("Image URL: $imageUrl");
                    } catch (error) {
                      print("Error uploading image: $error");
                    }
                  } else {
                    print("No image selected.");
                  }

                  // Create a new SubCategoryModel object
                  final newSubCategory = SubCategoryModel(
                    id: 'user_id',
                    category: selectedCategory ?? '',
                    subcategory: subcategoryNameController.text,
                    image: imageUrl,
                    timestamp: Timestamp.now(),
                  );

                  // Add subcategory to Firestore
                  await FirebaseFirestore.instance
                      .collection("SubCategory")
                      .add(newSubCategory.toJson())
                      .then((value) {
                    // Clear fields and reset state
                    subcategoryNameController.clear();
                    selectedImage = null;
                    setState(() {
                      isLoading = false; // Hide the loading indicator
                    });
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Subcategory Added Successfully")),
                    );
                  }).catchError((error) {
                    // Handle errors
                    print("Error adding subcategory: $error");
                    setState(() {
                      isLoading = false; // Hide the loading indicator
                    });
                  });
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text("Add Subcategory", style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500)),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
