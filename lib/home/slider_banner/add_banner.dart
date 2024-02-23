import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../helper/images.dart';

class AddBannerScreen extends StatefulWidget {
  const AddBannerScreen({super.key});

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl = '';
  File? selectedImage;
  bool isLoading = false;

  Future<void> addBannerToFireStore() async {
    if (selectedImage != null) {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('Banner_images');
      Reference referenceImageToUpload =
      referenceDirImages.child(uniqueFilename);
      try {
        await referenceImageToUpload.putFile(selectedImage!);
        imageUrl = await referenceImageToUpload.getDownloadURL();
        print("Image URL: $imageUrl");

        DocumentReference documentReference =
        await FirebaseFirestore.instance.collection("SliderBanner").add({
          'image': imageUrl,
        });

        // Use the document ID from the DocumentReference
        print("Document ID: ${documentReference.id}");

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Banner Added Successfully")),
        );
      } catch (error) {
        print("Error uploading image: $error");
      }
    } else {
      // Display an error message or take appropriate action
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Slider Banner', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              selectedImage != null
                  ? Image.file(selectedImage!, width: 200, height: 200, fit: BoxFit.cover,)
                  : Image.asset(imagePlaceholder, width: 200, height: 200),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                    if (file == null) return;
                    selectedImage = File(file.path);
                    setState(() {});
                  },
                  child: Text("Select Image", style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white),),
                ),
              ),


              const SizedBox(height: 20,),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Fixme: Call the method for add data here
                    addBannerToFireStore();

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator() // Show the progress indicator
                      : Text(
                    "Add Banner", style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
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