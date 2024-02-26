import 'package:admin/helper/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../../models/category_models.dart';
import '../../models/subcategory_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String? selectedCategory;
  String? selectedSubCategory;
  String? productName;
  String? productTitle;
  double? productPrice;
  double? salePrice; //
  DateTime? deliveryDate;
  List<File> selectedImages = [];
  String? productDetailTitle1;
  String? productDetail1;
  String? productDetailTitle2;
  String? productDetail2;
  String? productDetailTitle3;
  String? productDetail3;
  String? productDetailTitle4;
  String? productDetail4;
  List<String?> selectedColors = [];
  List<String?> selectedSizes = []; // New list for sizes

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); // Initialize Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Products', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: selectedImages.isNotEmpty
                    ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 120),
                      child: Center(
                        child: Image.file(
                          selectedImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                )
                    : Center(
                  child: Image.asset(imagePlaceholder)
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    List<XFile>? files = await imagePicker.pickMultiImage();

                    // Convert XFile to File and add to the list
                    selectedImages =
                        files.map((file) => File(file.path)).toList();
                    setState(() {});
                  },
                  child: Text(
                    "Select Images",
                    style: GoogleFonts.nunitoSans(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Product Name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Title',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productTitle = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Product Title';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Price',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    // Convert the input to a double
                    productPrice = double.tryParse(value);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Product Price';
                  }
                  // Validate if the input can be converted to a double
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // New TextFormField for Sale Price
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Sale Price (optional)',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  // Convert the input to a double or set it to null if empty
                  salePrice = value.isNotEmpty ? double.tryParse(value) : null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // Date Picker for Delivery Date
              ListTile(
                title: Text(
                  'Delivery Date',
                  style: GoogleFonts.nunitoSans(fontSize: 15),
                ),
                subtitle: deliveryDate == null
                    ? null
                    : Text(
                  'Selected Date: ${deliveryDate!.toLocal()}',
                  style: GoogleFonts.nunitoSans(fontSize: 15),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(

                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );

                  if (pickedDate != null && pickedDate != deliveryDate) {
                    setState(() {
                      deliveryDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Detail Title 1',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productDetailTitle1 = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Detail 1',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productDetail1 = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Detail Title 2',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productDetailTitle2 = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Detail 2',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productDetail2 = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Detail Title 3',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productDetailTitle3 = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Detail 3',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productDetail3 = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Detail Title 4',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productDetailTitle4 = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Product Detail 4',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    productDetail4 = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Colors (optional)',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  // Split the comma-separated string into a list of colors
                  selectedColors =
                      value.split(',').map((e) => e.trim()).toList();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // New TextFormField for Sizes
              TextFormField(
                style: GoogleFonts.nunitoSans(),
                decoration: InputDecoration(
                  labelText: 'Sizes (optional)',
                  labelStyle: GoogleFonts.nunitoSans(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                onChanged: (value) {
                  // Split the comma-separated string into a list of sizes
                  selectedSizes =
                      value.split(',').map((e) => e.trim()).toList();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CategoryDropdown(
                selectedCategory: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    // Reset subcategory when category changes
                    selectedSubCategory = null;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SubCategoryDropdown(
                selectedCategory: selectedCategory,
                selectedSubCategory: selectedSubCategory,
                onChanged: (value) {
                  setState(() {
                    selectedSubCategory = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    // Add the product to Firestore
                    _addProductToFirestore();
                  },
                  child: Text(
                    "Add Product",
                    style: GoogleFonts.nunitoSans(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProductToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Check if a user is authenticated
    if (user != null) {
      String userId = user.uid;

      // Replace this with your Firestore logic to add the product
      if (productName != null &&
          selectedCategory != null &&
          selectedSubCategory != null &&
          selectedImages.isNotEmpty &&
          productTitle != null &&
          productPrice != null &&
          deliveryDate != null &&
          productDetailTitle1 != null &&
          productDetail1 != null &&
          productDetailTitle2 != null &&
          productDetail2 != null &&
          productDetailTitle3 != null &&
          productDetail3 != null &&
          productDetailTitle4 != null &&
          productDetail4 != null) {
        try {
          // Format the product price with Indian currency symbol
          final formattedPrice =
          NumberFormat.currency(locale: 'en_IN', symbol: '')
              .format(productPrice!);
          final formattedSalePrice =
          NumberFormat.currency(locale: 'en_IN', symbol: '')
              .format(salePrice!);

          // Example: Saving product to Firestore
          await FirebaseFirestore.instance.collection('Products').add({
            'productName': productName,
            'productTitle': productTitle,
            'productPrice': formattedPrice,
            'salePrice': formattedSalePrice,
            'deliveryDate': deliveryDate,
            'category': selectedCategory,
            'subCategory': selectedSubCategory,
            'images': await _uploadImagesToStorage(selectedImages),
            'user_id': userId,
            'productDetailTitle1': productDetailTitle1,
            'productDetail1': productDetail1,
            'productDetailTitle2': productDetailTitle2,
            'productDetail2': productDetail2,
            'productDetailTitle3': productDetailTitle3,
            'productDetail3': productDetail3,
            'productDetailTitle4': productDetailTitle4,
            'productDetail4': productDetail4,
            'colors': selectedColors,
            'sizes': selectedSizes,
            // ... (other fields)
          });

          // Show a success message or navigate to a different screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully!')),
          );
        } catch (e) {
          // Handle errors
          print('Error adding product: $e');
        }
      } else {
        // Show an error message if any required fields are missing
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all required fields')),
        );
      }
    } else {
      // If the user is not authenticated, prompt them to log in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to add a product')),
      );
    }
  }

  Future<List<String>> _uploadImagesToStorage(List<File> images) async {
    List<String> imageUrls = [];

    for (File image in images) {
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$fileName');
        UploadTask uploadTask = storageReference.putFile(image);
        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();
          imageUrls.add(imageUrl);
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return imageUrls;
  }
}

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown(
      {required this.selectedCategory, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final categoryDocs = snapshot.data!.docs;
        List<CategoryModel> categories = [];

        for (var doc in categoryDocs) {
          final category = CategoryModel.fromSnapshot(doc);
          categories.add(category);
        }

        return DropdownButtonFormField<String>(
          style: GoogleFonts.nunitoSans(),
          value: selectedCategory,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: 'Select Category',
            labelStyle: GoogleFonts.nunitoSans(),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          items: categories.map((CategoryModel category) {
            return DropdownMenuItem<String>(
              value: category.category,
              child: Text(
                category.category,
                style: GoogleFonts.nunitoSans(color: Colors.black),
              ),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a Category';
            }
            return null;
          },
        );
      },
    );
  }
}

class SubCategoryDropdown extends StatelessWidget {
  final String? selectedSubCategory;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const SubCategoryDropdown(
      {required this.selectedSubCategory,
        required this.selectedCategory,
        required this.onChanged,
        super.key});

  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null) {
      return Text('Please select a category first.', style: GoogleFonts.nunitoSans(),);
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('SubCategory').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final subCategoryDocs = snapshot.data!.docs;
        List<SubCategoryModel> subCategories = [];

        for (var doc in subCategoryDocs) {
          final subCategory = SubCategoryModel.fromSnapshot(doc);

          // Filter subcategories based on the selected category
          if (subCategory.category == selectedCategory) {
            subCategories.add(subCategory);
          }
        }

        // Check if a category is selected before showing the dropdown
        return selectedCategory != null
            ? DropdownButtonFormField<String>(
          style: GoogleFonts.nunitoSans(),
          value: selectedSubCategory,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: 'Select SubCategory',
            labelStyle: GoogleFonts.nunitoSans(),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          items: subCategories.map((SubCategoryModel subcategory) {
            return DropdownMenuItem<String>(
              value: subcategory.subcategory,
              child: Text(
                subcategory.subcategory,
                style: GoogleFonts.nunitoSans(color: Colors.black),
              ),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a SubCategory';
            }
            return null;
          },
        )
            : Container();
      },
    );
  }
}