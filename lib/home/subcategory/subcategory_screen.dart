import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helper/colors.dart';
import '../../helper/strings.dart';
import '../../models/subcategory_model.dart';
import 'addsubcategory_screen.dart';
import 'edit_subcategory_screen.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  // Define a callback function to handle category deletion
  void _deleteSubCategory(String subCategoryID) {
    FirebaseFirestore.instance.collection('SubCategory').doc(subCategoryID).delete().then((value) {
      // Show a toast message when a category is deleted successfully
      Fluttertoast.showToast(
        msg: 'Category deleted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }).catchError((error) {
      // Show a toast message when there is an error deleting the category
      Fluttertoast.showToast(
        msg: 'Failed to delete category',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub Category', style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontWeight: FontWeight.bold)),),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSubCategoryScreen()));
                },
                child: Text(addSubCategory, style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15)),),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: textFormBgColor.withOpacity(.10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: buttonBorderColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Categories',
                      hintStyle: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Text(serialNo, style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),)),
                  Expanded(child: Text('Category \nName', style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),)),
                  Expanded(child: Text('S. Category \n Name', style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),)),
                  Expanded(child: Text('S. Category \n Image', style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),)),
                ],
              ),
              // Pass the deleteCategory callback to CategoryListWidget
              CategoryListWidget(deleteCategory: _deleteSubCategory),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryListWidget extends StatelessWidget {
  final Function(String) deleteCategory; // Callback function

  const CategoryListWidget({super.key, required this.deleteCategory});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('SubCategory').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final categoryDocs = snapshot.data!.docs;
        List<SubCategoryModel> categories = [];

        for (var doc in categoryDocs) {
          final subcategory = SubCategoryModel.fromSnapshot(doc);
          categories.add(subcategory);
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text((index + 1).toString(), style: GoogleFonts.nunitoSans(),),),
                      // const Spacer(),
                      Expanded(child: Text(category.category, style: GoogleFonts.nunitoSans(),)),
                      // const Spacer(),
                      Expanded(child: Text(category.subcategory, style: GoogleFonts.nunitoSans(),)),
                      // const Spacer(),
                      Expanded(child: Image.network(category.image, width: 100, height: 50)),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Container(
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: buttonBorderColor),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditSubCategoryScreen(subCategory: category,)));
                          }, child: Text('Edit', style: GoogleFonts.nunitoSans(),),

                          )
                      ),


                      Container(
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: buttonBorderColor),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Show a confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text('Are you sure you want to delete this category?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Dismiss the dialog
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Delete the category and dismiss the dialog
                                        deleteCategory(category.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('Delete', style: GoogleFonts.nunitoSans()),
                        ),
                      )


                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}