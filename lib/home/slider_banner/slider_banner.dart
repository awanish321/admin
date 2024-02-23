import 'package:admin/helper/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helper/colors.dart';
import '../../helper/strings.dart';
import '../../models/banner_model.dart';
import 'add_banner.dart';



class SliderBannerScreen extends StatefulWidget {
  const SliderBannerScreen({super.key});

  @override
  State<SliderBannerScreen> createState() => _SliderBannerScreenState();
}

class _SliderBannerScreenState extends State<SliderBannerScreen> {

  bool _isDeleting = false;

  void _deleteBanner(String bannerID) {
    setState(() {
      _isDeleting = true;
    });
    FirebaseFirestore.instance
        .collection('SliderBanner')
        .doc(bannerID)
        .delete()
        .then((value) {
      // Show a toast message when a category is deleted successfully
      Fluttertoast.showToast(
        msg: 'SubCategory deleted successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }).catchError((error) {
      // Show a toast message when there is an error deleting the category
      Fluttertoast.showToast(
        msg: 'Failed to delete SubCategory',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }).whenComplete(() {
      setState(() {
        _isDeleting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slider Banner', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddBannerScreen()));
                },
                child: Text(addBanner, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child: Text(serialNo, style: GoogleFonts.nunitoSans(fontSize: 16, fontWeight: FontWeight.w700),)),
                  const Gap(50),
                  Expanded(child: Text(bannerImage, style: GoogleFonts.nunitoSans(fontSize: 16, fontWeight: FontWeight.w700),)),
                  const Gap(20),
                ],
              ),
              _isDeleting
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : SliderListWidget(deleteBanner: _deleteBanner),
            ],
          ),
        ),
      ),
    );
  }
}


class SliderListWidget extends StatelessWidget {
  final Function(String) deleteBanner;
  const SliderListWidget({super.key, required this.deleteBanner});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('SliderBanner').snapshots(),
      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Image.asset(imagePlaceholder, height: 500, width: 500,)
          );
        }


        final bannerDocs = snapshot.data!.docs;
        List<BannerModel> bannerList = [];

        for (var doc in bannerDocs) {
          final banner = BannerModel.fromSnapshot(doc);
          bannerList.add(banner);
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bannerList.length,
          itemBuilder: (context, index) {
            final banner = bannerList[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text((index + 1).toString())),
                      Expanded(child: Image.network(banner.image, width: 120, height: 80, )),
                    ],
                  ),

                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: buttonBorderColor),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextButton(onPressed: () {

                          }, child: Text('Edit', style: GoogleFonts.nunitoSans(),),

                          )
                      ),

                      const SizedBox(width: 20),

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
                                  title: Text('Confirm Deletion', style: GoogleFonts.nunitoSans(),),
                                  content: Text('Are you sure you want to delete this Banner?', style: GoogleFonts.nunitoSans(),),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Dismiss the dialog
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel', style: GoogleFonts.nunitoSans(),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteBanner(banner.id);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Yes', style: GoogleFonts.nunitoSans(),),
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