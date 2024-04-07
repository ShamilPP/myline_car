class Car {
  String? id;
  String name, phone, place, year, km, thumbUrl;
  List<String> images;
  DateTime createdTime;

  Car({
    this.id,
    required this.name,
    required this.phone,
    required this.place,
    required this.year,
    required this.km,
    required this.thumbUrl,
    required this.images,
    required this.createdTime,
  });
}
