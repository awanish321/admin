import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helper/colors.dart';
import '../../helper/strings.dart';
import 'add_products_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProductScreen(),
                    ),
                  );
                },
                child: Text(addProduct, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
              ),

              const SizedBox(height: 20,),
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
                      hintText: 'Search Product',
                      hintStyle: GoogleFonts.nunitoSans(color: Colors.grey, fontSize: 15)
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child: Text(serialNo, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                  Expanded(child: Text(categoryName, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                  Expanded(child: Text(productName, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                  Expanded(child: Text(subCategoryImage, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                ],
              ),

              const SizedBox(height: 10,),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Products').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final documents = snapshot.data!.docs;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final data = documents[index].data() as Map<String, dynamic>;
                      // Get the list of images
                      List<dynamic> imagesList = data['images'];
                      // Fetch the first image
                      String firstImage = imagesList.isNotEmpty ? imagesList.first : ''; // Check if the list is not empty
                      return Row(
                          children: [
                            Expanded(child: Text((index + 1).toString(), style: GoogleFonts.nunitoSans(),)),
                            Expanded(child: Text('${data['category']}', style: GoogleFonts.nunitoSans(),)),
                            Expanded(child: Text(data['productName'], style: GoogleFonts.nunitoSans(),)),
                            Expanded(child: Image.network(firstImage, width: 120, height: 100, )),

                            // Add more fields as needed
                          ],
                        );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
