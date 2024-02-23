import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/subcategory_model.dart';

class EditSubCategoryScreen extends StatefulWidget {
  final SubCategoryModel subCategory;

  const EditSubCategoryScreen({super.key, required this.subCategory});

  @override
  State<EditSubCategoryScreen> createState() => _EditSubCategoryScreenState();
}

class _EditSubCategoryScreenState extends State<EditSubCategoryScreen> {
  TextEditingController? subcategoryNameController;
  String? imageUrl;
  File? selectedImage;
  bool isLoading = false;
  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  String? selectedCategory; // Variable to hold the selected category
  List<String> dropdownItems = []; // List to store dropdown items

  @override
  void initState() {
    super.initState();
    subcategoryNameController =
        TextEditingController(text: widget.subCategory.subcategory);
    imageUrl = widget.subCategory.image;
    selectedCategory = widget.subCategory.category;
    fetchDropdownItems();
  }

  // Function to fetch dropdown items from Firestore
  Future<void> fetchDropdownItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection("Categories").get();

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
        title: Text('Edit SubCategory', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Image picker
            selectedImage != null
                ? Image.file(selectedImage!, width: 200, height: 200)
                : imageUrl != null
                ? Image.network(imageUrl!, width: 200, height: 200)
                : Container(),
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
                child: Text("Select Image", style: GoogleFonts.nunitoSans(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),),
              ),
            ),
            const SizedBox(height: 20),
            // Dropdown menu for categories
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: dropdownItems
                  .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category, style: GoogleFonts.nunitoSans(),),
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
            // Button to edit subcategory
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
                      imageUrl =
                      await referenceImageToUpload.getDownloadURL();
                      print("Image URL: $imageUrl");
                    } catch (error) {
                      print("Error uploading image: $error");
                    }
                  } else {
                    print("No image selected.");
                  }

                  // Create a new SubCategoryModel object
                  final updatedSubCategory = SubCategoryModel(
                    id: widget.subCategory.id,
                    category: selectedCategory ?? '',
                    subcategory: subcategoryNameController!.text,
                    image: imageUrl ?? '',
                    timestamp: widget.subCategory.timestamp,
                  );

                  // Update subcategory in Firestore
                  await FirebaseFirestore.instance
                      .collection("SubCategory")
                      .doc(widget.subCategory.id)
                      .update(updatedSubCategory.toJson())
                      .then((value) {
                    setState(() {
                      isLoading = false; // Hide the loading indicator
                    });
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Subcategory Updated Successfully")),
                    );
                  }).catchError((error) {
                    // Handle errors
                    print("Error updating subcategory: $error");
                    setState(() {
                      isLoading = false; // Hide the loading indicator
                    });
                  });
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text("Update SubCategory", style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 15),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
