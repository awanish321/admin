// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class SubCategoryModel {
//   final String id;
//   final String category;
//   final String subcategory;
//   final String image;
//
//   SubCategoryModel({
//     required this.id,
//     required this.category,
//     required this.subcategory,
//     required this.image,
//   });
//
//
//   factory SubCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
//     return SubCategoryModel(
//       id: snapshot.id, // Assign the document ID to the id field
//       category: snapshot['category'],
//       subcategory: snapshot['subcategory'],
//       image: snapshot['image'],
//     );
//   }
//
//
//   factory SubCategoryModel.fromJson(DocumentSnapshot json) {
//     return SubCategoryModel(
//       id: json.id,
//       category: json['category'],
//       subcategory: json['subcategory'],
//       image: json['image'],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategoryModel {
  final String id;
  final String category;
  final String subcategory;
  final String image;
  final Timestamp timestamp;

  SubCategoryModel({
    required this.id,
    required this.category,
    required this.subcategory,
    required this.image,
    required this.timestamp,

  });

  factory SubCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SubCategoryModel(
      id: snapshot.id,
      category: snapshot['category'],
      subcategory: snapshot['subcategory'],
      timestamp: snapshot['timestamp'],
      image: snapshot['image'],
    );
  }

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      category: json['category'],
      subcategory: json['subcategory'],
      timestamp: json['timestamp'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'subcategory': subcategory,
      'timestamp': timestamp,
      'image': image,
    };
  }
}

