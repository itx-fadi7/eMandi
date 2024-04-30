import 'package:flutter/material.dart';

class Data {
  String id;
  String image;
  String title;
  String postedDate;
  String Rs;
  String location;
  String key;
  String views;
  String age;
  String description;
  String ownerName;
  String ownerPho;
  String animalQuantity;
  String category;
  String email;
  Data({
    this.id = '',
    required this.email,
    required this.image,
    required this.title,
    required this.postedDate,
    required this.Rs,
    required this.location,
    required this.key,
    required this.views,
    required this.age,
    required this.description,
    required this.ownerName,
    required this.ownerPho,
    required this.animalQuantity,
    required this.category,
  });
}
