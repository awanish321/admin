import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/colors.dart';
import '../../helper/strings.dart';
import '../../models/category_models.dart';
import 'addcategory_screen.dart';
import 'editcategory_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // Define a callback function to handle category deletion
  void _deleteCategory(String categoryID) {
    FirebaseFirestore.instance.collection('Categories').doc(categoryID).delete().then((value) {
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
        title: Text('Category', style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontWeight: FontWeight.bold)),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCategoryScreen()));
                },
                child: Text(addCategory, style: GoogleFonts.nunitoSans(color: Colors.white, fontSize: 15)),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                height: 50,
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
                      hintStyle: GoogleFonts.nunitoSans(color: Colors.grey)
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Text(serialNo, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                  Expanded(child: Text(categoryName, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                  Expanded(child: Text(categoryImage, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                ],
              ),
              CategoryListWidget(deleteCategory: _deleteCategory),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryListWidget extends StatelessWidget {
  final Function(String) deleteCategory;
  const CategoryListWidget({super.key, required this.deleteCategory});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text((index + 1).toString(), style: GoogleFonts.nunitoSans(),)),
                      Expanded(child: Text(category.category, style: GoogleFonts.nunitoSans(),)),
                      Expanded(child: Image.network(category.image, width: 100, height: 50)),
                    ],
                  ),
                  const SizedBox(height: 10,),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditCategoryScreen(category: category, image: category.image)));
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text('Are you sure you want to delete this category?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
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