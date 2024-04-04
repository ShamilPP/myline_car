import 'package:flutter/material.dart';
import 'package:myline_car/model/result.dart';
import 'package:myline_car/view/screens/car/car_screen.dart';
import 'package:myline_car/view/screens/order/orders_screen.dart';
import 'package:myline_car/view/screens/profile/profile_screen.dart';
import 'package:myline_car/view/widgets/loading_network_image.dart';
import 'package:myline_car/view_model/cars_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyLine'),
        // backgroundColor: colors.bgColor,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Orders':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
                  break;
                case 'Profile':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Orders', 'Profile'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Consumer<CarsProvider>(
        builder: (ctx, provider, child) {
          if (provider.cars.status == Status.success) {
            var cars = provider.cars.data!;
            if (cars.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20, right: 15, left: 15),
                    child: Text("Your Vehicles: ${cars.length}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ListView.builder(
                        itemCount: cars.length,
                        itemBuilder: (ctx, index) {
                          var car = cars[index];
                          return Card(
                            elevation: 5, // Shadow elevation
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => CarScreen(car: car)),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: LoadingNetworkImage(
                                          car.images.first,
                                          height: 30,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        )),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        car.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'No cars',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            }
          } else if (provider.cars.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.cars.status == Status.loading) {
            return Center(child: Text(provider.cars.message.toString()));
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CarScreen()));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
