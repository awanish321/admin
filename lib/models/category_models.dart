// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class CategoryModel {
//   String id;
//   String category;
//   String image;
//
//   CategoryModel({
//     required this.id,
//     required this.category,
//     required this.image,
//   });
//
//   factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
//     return CategoryModel(
//       id: snapshot.id,
//       category: snapshot['category'],
//       image: snapshot['image'],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String category;
  final String image;
  final Timestamp timestamp;
  final String id;

  CategoryModel({
    required this.category,
    required this.image,
    required this.timestamp,
    required this.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['category'],
      image: json['image'],
      timestamp: json['timestamp'],
      id: json['user_id'],
    );
  }


  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return CategoryModel(
      id: snapshot.id,
      category: snapshot['category'],
      image: snapshot['image'],
      timestamp: snapshot['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'image': image,
      'timestamp': timestamp,
      'user_id': id,
    };
  }
}

