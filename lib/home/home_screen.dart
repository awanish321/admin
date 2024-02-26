import 'package:admin/home/slider_banner/slider_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helper/images.dart';
import 'category/category_screen.dart';
import 'components/order_screen.dart';
import 'products/products_screen.dart';
import 'subcategory/subcategory_screen.dart';
import 'components/users_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: ListTileTheme(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Gap(80),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                },
                leading: const Icon(Iconsax.home,),
                title: Text('Home', style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.bold),),
              ),
              ListTile(
                onTap: () {
                  _signOut();
                },
                leading: const Icon(Iconsax.logout),
                title: Text('Logout', style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.bold),),
              ),
              DefaultTextStyle(
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: Colors.black,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: const Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.grey,
        elevation: 0,
        title: Text("A Mart", style: GoogleFonts.nunitoSans(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: ListView(
          // Use ListView for scrollable content
          children: [
            Center(
                child: Text("AMart Admin", style: GoogleFonts.nunitoSans(fontSize: 25, fontWeight: FontWeight.bold),)),
            const Gap(20),
            Row(
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("Categories").snapshots(),
                        builder: (context, categorySnapshot) {
                          if (categorySnapshot.connectionState == ConnectionState.waiting) {
                            // return const CircularProgressIndicator();
                          }

                          int categoryCount = categorySnapshot.data?.docs.length ?? 0;

                          return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection("SubCategory").snapshots(),
                              builder: (context, subCategorySnapshot) {
                                if (subCategorySnapshot.connectionState == ConnectionState.waiting) {
                                  // return const CircularProgressIndicator();
                                }

                                int subCategoryCount = subCategorySnapshot.data?.docs.length ?? 0;

                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection("SliderBanner").snapshots(),
                                  builder: (context, sliderBannerSnapshot) {
                                    if (sliderBannerSnapshot.connectionState == ConnectionState.waiting) {
                                      // return const CircularProgressIndicator();
                                    }

                                    int sliderBannerCount = sliderBannerSnapshot.data?.docs.length ?? 0;

                                    return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection("Products").snapshots(),
                                      builder: (context, productsSnapshot) {
                                        if (productsSnapshot.connectionState == ConnectionState.waiting) {
                                          // return const CircularProgressIndicator();
                                        }

                                        int productsCount = productsSnapshot.data?.docs.length ?? 0;

                                        return StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection("users").snapshots(),
                                          builder: (context, usersSnapshot) {
                                            if (usersSnapshot.connectionState == ConnectionState.waiting) {
                                              // return const CircularProgressIndicator();
                                            }

                                            int usersCount = usersSnapshot.data?.docs.length ?? 0;

                                            // Define a list of card data with images, text, and onTap handlers
                                            List<Map<String,
                                                dynamic>> cardData = [
                                              {"image": categoryIcon, "text": "Category", "count": categoryCount.toString(), "onTap": _openCategoryScreen},
                                              {"image": subCategoryIcon, "text": "SubCategory", "count": subCategoryCount.toString(), "onTap": _openSubCategoryScreen},
                                              {"image": productsIcon, "text": "Products", "count": productsCount.toString(), "onTap": _openProductsScreen},
                                              {"image": usersIcon, "text": "All Users", "count": usersCount.toString(), "onTap": _openUsersScreen},
                                              {"image": sliderBannerIcon, "text": "Slider Banner", "count": sliderBannerCount.toString(), "onTap": _openSliderBannerScreen},
                                              {"image": ordersIcon, "text": "Orders", "count": "0", "onTap": _openOrdersScreen},
                                              {"image": brandsIcon, "text": "Brands", "count": "0", "onTap": _openOrdersScreen},
                                              {"image": cardsIcon, "text": "Cards", "count": "0", "onTap": _openOrdersScreen},
                                            ];

                                            return GridView.count(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1.0,
                                              mainAxisSpacing: 10.0,
                                              crossAxisSpacing: 10.0,
                                              shrinkWrap: true,
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              children: List.generate(
                                                  cardData.length, (index) {
                                                    return GestureDetector(
                                                      onTap: cardData[index]["onTap"],
                                                      child: Card(
                                                        color: CupertinoColors.systemGrey3,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Image.asset(cardData[index]["image"], width: 48.0, height: 48.0,),
                                                            const SizedBox(height: 8.0),
                                                            Text(cardData[index]["text"], style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),),
                                                            const SizedBox(height: 8.0),
                                                            Text(cardData[index]["count"], style: GoogleFonts.nunitoSans(fontSize: 15),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                          );
                        }
                    )
                          )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openCategoryScreen() {
    // Navigate to the CategoryScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CategoryScreen(),
    ));
  }

  void _openSubCategoryScreen() {
    // Navigate to the SubCategoryScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SubCategoryScreen(),
    ));
  }

  void _openProductsScreen() {
    // Navigate to the ProductsScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ProductsScreen(),
    ));
  }

  void _openUsersScreen() {
    // Navigate to the UsersScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const UsersScreen(),
    ));
  }

  void _openSliderBannerScreen() {
    // Navigate to the SliderBannerScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SliderBannerScreen(),
    ));
  }

  void _openOrdersScreen() {
    // Navigate to the OrdersScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const OrderScreen(),
    ));
  }
}

void main() {
  runApp(MaterialApp(
    home: const HomeScreen(),
    // Define routes for your different screens here
    routes: {
      '/category': (context) => const CategoryScreen(),
      '/subCategory': (context) => const SubCategoryScreen(),
      '/products': (context) => const ProductsScreen(),
      '/users': (context) => const UsersScreen(),
      '/sliderBanner': (context) => const SliderBannerScreen(),
      '/orders': (context) => const OrderScreen(),
    },
  ));
}
