import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  String? id;
  String image, name, phone;
  List<String> places;
  GeoPoint location;
  DateTime createdTime;

  Car({
    this.id,
    required this.image,
    required this.name,
    required this.phone,
    required this.places,
    required this.location,
    required this.createdTime,
  });
}
