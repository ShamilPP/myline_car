import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myline_car/model/car.dart';
import 'package:myline_car/model/result.dart';
import 'package:myline_car/model/user.dart';
import 'package:myline_car/view/screens/car/widgets/car_deatils_photo.dart';
import 'package:myline_car/view/screens/car/widgets/car_details_item.dart';
import 'package:myline_car/view_model/cars_provider.dart';
import 'package:myline_car/view_model/user_provider.dart';
import 'package:provider/provider.dart';

class CarScreen extends StatefulWidget {
  final Car? car;

  const CarScreen({super.key, this.car});

  @override
  State<CarScreen> createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  String? imageUrl, imageUrl2, imageUrl3, name, phone, year, price, type, km;

  @override
  void initState() {
    if (widget.car != null) {
      imageUrl = widget.car!.images[0];
      imageUrl2 = widget.car!.images[1];
      imageUrl3 = widget.car!.images[2];
      name = widget.car!.name;
      // phone = widget.car!.phone;
      year = widget.car!.year;
      price = widget.car!.price;
      type = widget.car!.type;
      km = widget.car!.km;
    }
    User? user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      phone = user.phone;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car != null ? widget.car!.name : "Create new car"),
        actions: [if (widget.car != null) IconButton(onPressed: () {}, icon: const Icon(Icons.delete))],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarDetailsItem(
              title: 'Name',
              content: name,
              onUpdate: (result) {
                setState(() {
                  name = result;
                });
              },
            ),
            CarDetailsItem(
              title: 'Phone',
              content: phone,
              editable: false,
              onUpdate: (result) {},
            ),
            CarDetailsItem(
              title: 'Year',
              content: year,
              onUpdate: (result) {
                setState(() {
                  year = result;
                });
              },
            ),
            CarDetailsItem(
              title: 'Price',
              content: price,
              onUpdate: (result) {
                setState(() {
                  price = result;
                });
              },
            ),
            CarDetailsItem(
              title: 'Type',
              content: type,
              onUpdate: (result) {
                setState(() {
                  type = result;
                });
              },
            ),
            CarDetailsItem(
              title: 'KM',
              content: km,
              onUpdate: (result) {
                setState(() {
                  km = result;
                });
              },
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Photos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  CarDetailsPhoto(
                    imageUrl,
                    onUpdate: (result) {
                      setState(() {
                        imageUrl = result;
                      });
                    },
                  ),
                  CarDetailsPhoto(
                    imageUrl2,
                    onUpdate: (result) {
                      setState(() {
                        imageUrl2 = result;
                      });
                    },
                  ),
                  CarDetailsPhoto(
                    imageUrl3,
                    onUpdate: (result) {
                      setState(() {
                        imageUrl3 = result;
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (imageUrl?.isNotEmpty == true &&
              imageUrl2?.isNotEmpty == true &&
              imageUrl3?.isNotEmpty == true &&
              name?.isNotEmpty == true &&
              phone?.isNotEmpty == true &&
              price?.isNotEmpty == true &&
              type?.isNotEmpty == true &&
              year?.isNotEmpty == true &&
              km?.isNotEmpty == true) {
            Car car = Car(name: name!, phone: phone!, price: price!, type: type!, year: year!, km: km!, thumbUrl: imageUrl!, images: [imageUrl!, imageUrl2!, imageUrl3!]);
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
        child: const Icon(Icons.save),
      ),
    );
  }
}
