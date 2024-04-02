import 'package:flutter/foundation.dart';

class Car {
  String? id;
  String name, phone, price, type, year, km, thumbUrl;
  List<String> images;

  Car({
    this.id,
    required this.name,
    required this.phone,
    required this.price,
    required this.type,
    required this.year,
    required this.km,
    required this.thumbUrl,
    required this.images,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Car &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          phone == other.phone &&
          price == other.price &&
          type == other.type &&
          year == other.year &&
          km == other.km &&
          thumbUrl == other.thumbUrl &&
          listEquals(images, other.images);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ phone.hashCode ^ price.hashCode ^ type.hashCode ^ year.hashCode ^ km.hashCode ^ thumbUrl.hashCode ^ images.hashCode;
}
