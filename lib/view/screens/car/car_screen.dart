import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myline_car/model/car.dart';
import 'package:myline_car/model/result.dart';
import 'package:myline_car/model/user.dart';
import 'package:myline_car/utils/colors.dart';
import 'package:myline_car/view_model/cars_provider.dart';
import 'package:myline_car/view_model/user_provider.dart';
import 'package:myline_car/view_model/utils/helper.dart';
import 'package:provider/provider.dart';

class CarScreen extends StatefulWidget {
  final Car? car;

  const CarScreen({super.key, this.car});

  @override
  State<CarScreen> createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  String? image, phone;
  TextEditingController nameController = TextEditingController();
  List<String> places = [];

  GeoPoint? location;
  String? locationName;
  bool isFetchingLocation = false;

  @override
  void initState() {
    User? user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      phone = user.phone;
    }
    if (widget.car != null) {
      image = widget.car!.image;
      nameController.text = widget.car!.name;
      // phone = widget.car!.phone;
      places = widget.car!.places;

      // Load location name
      isFetchingLocation = true;
      updateLocationName(widget.car!.location.latitude, widget.car!.location.longitude).then((value) {
        setState(() {
          isFetchingLocation = false;
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car != null ? widget.car!.name : "Create new car"),
        actions: [
          if (widget.car != null)
            IconButton(
                onPressed: () {
                  deleteCar();
                },
                icon: const Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () async {
                    if (image == null) {
                      final ImagePicker picker = ImagePicker();
                      final XFile? newImage = await picker.pickImage(source: ImageSource.gallery);
                      if (newImage != null) {
                        setState(() {
                          image = newImage.path;
                        });
                      }
                    } else {
                      Fluttertoast.showToast(msg: 'Unable to update the image during the updating process.');
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: image != null
                        ? image!.isLink
                            ? Image.network(image!, fit: BoxFit.cover, loadingBuilder: Helper.imageLoadingBuilder)
                            : Image.file(File(image!), fit: BoxFit.fill)
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                color: Colors.grey,
                                size: 18,
                              ),
                              Text('Add a photo', style: TextStyle(color: Colors.grey, fontSize: 10)),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.directions_car, color: colors.primaryColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.primaryColor, width: 1),
                  ),
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: TextField(
                enabled: false,
                controller: TextEditingController(text: phone),
                decoration: InputDecoration(
                  labelText: "Phone",
                  prefixIcon: Icon(Icons.phone, color: colors.primaryColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: colors.primaryColor, width: 1),
                  ),
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.location_on,
                        color: colors.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        isFetchingLocation ? 'Loading' : locationName ?? 'Click "GPS" Button',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: isFetchingLocation
                          ? const CircularProgressIndicator()
                          : IconButton(
                              onPressed: () {
                                updateLocation();
                              },
                              icon: const Icon(Icons.gps_fixed, color: Colors.white),
                              style: IconButton.styleFrom(backgroundColor: colors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                            ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Text(
                'Places',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
              child: GridView.count(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  ...places.map((String item) {
                    return Container(
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: AutoSizeText(
                                  item,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 12,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    places.remove(item);
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 20,
                                ),
                                padding: EdgeInsets.zero)
                          ],
                        ));
                  }).toList(),
                  IconButton(
                      onPressed: addNewPlace,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String name = nameController.text;
          if (image?.isNotEmpty == true && name.isNotEmpty == true && phone?.isNotEmpty == true && location != null) {
            Car car = Car(
              image: image!,
              name: name,
              phone: phone!,
              places: places,
              location: location!,
              createdTime: DateTime.now(),
            );
            showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
            //if car is null that's mean creating new car
            late Result<Car> result;
            if (widget.car == null) {
              result = await context.read<CarsProvider>().uploadCar(car);
            } else {
              car.id = widget.car!.id;
              if ((widget.car!) != car) {
                result = await context.read<CarsProvider>().updateCar(car);
              } else {
                result = Result.success(car);
              }
            }
            if (result.status == Status.error) {
              Fluttertoast.showToast(msg: result.message!, toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red);
            }
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Fluttertoast.showToast(msg: 'Fill all boxes', backgroundColor: Colors.red);
          }
        },
        label: Text(widget.car != null ? 'Update' : 'Save'),
        tooltip: widget.car != null ? 'Update' : 'Save',
        icon: const Icon(Icons.save),
      ),
    );
  }

  void updateLocation() async {
    setState(() {
      isFetchingLocation = true;
    });
    await Helper.turnOnLocation();
    Position position = await Geolocator.getCurrentPosition();
    location = GeoPoint(position.latitude, position.longitude);
    await updateLocationName(position.latitude, position.longitude);
    setState(() {
      isFetchingLocation = false;
    });
  }

  Future<void> updateLocationName(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    locationName = "${place.locality}, ${place.postalCode}, ${place.country}";
  }

  addNewPlace() {
    TextEditingController placeController = TextEditingController();
    showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add place',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: SizedBox(
                      child: TextField(
                        controller: placeController,
                        decoration: const InputDecoration(
                          hintText: 'Enter the place',
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: colors.primaryColor, foregroundColor: Colors.white),
                          onPressed: () {
                            String newPlace = placeController.text;
                            if (!places.contains(newPlace) && newPlace.isNotEmpty) {
                              setState(() {
                                places.add(newPlace);
                              });
                              Navigator.pop(ctx);
                            }
                          },
                          child: const Text('Create')),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void deleteCar() {
    Provider.of<CarsProvider>(context, listen: false).deleteCar(widget.car!);
    Navigator.pop(context);
  }
}
