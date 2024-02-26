import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Users", style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final usersData = snapshot.data!.docs;
            List<UserModel> users = [];
        
            for (var doc in usersData) {
              final user = UserModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
              users.add(user);
            }
        
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Container(
                       height: 250,
                       width: double.infinity,

                       decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey.withOpacity(0.7), width: 1),
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Expanded(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(flex: 3,child: Text('Name', style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                                   Expanded(flex: 5, child: Text('${user.firstName} ${user.lastName}', style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                                 ],
                               ),
                             ),
                             const Gap(10),
                             Expanded(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(flex: 3,child: Text('Username', style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                                   Expanded(flex: 5, child: Text(user.userName, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                                 ],
                               ),
                             ),
                             const Gap(10),
                             Expanded(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(flex: 3,child: Text('User ID', style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                                   Expanded(flex: 5, child: Text(user.id, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,)),
                                 ],
                               ),
                             ),
                             const Gap(10),
                             Expanded(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(flex: 3,child: Text('E-Mail', style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                                   Expanded(flex: 5, child: Text(user.email, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,)),
                                 ],
                               ),
                             ),
                             const Gap(10),
                             Expanded(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(flex: 3,child: Text('Phone Number', style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                                   Expanded(flex: 5, child: Text(user.phoneNumber, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,)),
                                 ],
                               ),
                             ),
                             const Gap(10),
                             Expanded(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(flex: 3,child: Text('Gender', style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                                   Expanded(flex: 5, child: Text(user.gender, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,)),
                                 ],
                               ),
                             ),
                             const Gap(10),
                             Expanded(
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(flex: 3,child: Text('Date of Birth', style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),)),
                                   Expanded(flex: 5, child: Text(user.dob, style: GoogleFonts.nunitoSans(fontSize: 15, fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,)),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),
                     )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );;
  }
}
